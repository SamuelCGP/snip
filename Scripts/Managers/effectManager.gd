extends Control
class_name EffectManager

signal effectStarted(effect: CardEffectData)
signal effectAttempted(effect: CardEffectData)
signal effectExecuted(effect: CardEffectData)

@export var promptScene: PackedScene

@onready var cardSelector: CardSelector = $CardSelector

var effects: Array[CardEffectData]
var activatingEffect: bool


func addEffect(effect: CardEffectData):
	effects.append(effect)


func removeEffect(effect: CardEffectData):
	effects.erase(effect)


func addCardEffects(card: CardNode):
	for effect in card.cardData.effects:
		effect.source = card
		addEffect(effect)


func onCardAddedToHand(card: CardNode):
	addCardEffects(card)


func onMageSummoned(card: CardNode):
	addCardEffects(card)


func onCardSummon(card: CardNode):
	for effect in effects:
		effect = effect as CardEffectData
		if card == effect.source:
			if effect.triggerEvent == CardEffectData.EffectTriggerEvent.SUMMON:
				if effect.triggerParams.target[0].isSelf && effect.source != card:
					return

				if !CardFilter.validateFilter(
					card.cardData, CardFilter.deserialize(effect.triggerParams.target)[0]
				):
					return

				attemptEffect(effect)

func attemptEffect(effect: CardEffectData):
	effectAttempted.emit(effect)

func prompt(text: String, options: Array[String] = ["Yes", "No"]) -> int:
	var promptNode: Prompt = promptScene.instantiate()
	add_child(promptNode)
	promptNode.start(text, options)
	await promptNode.optionSelected
		
	var option: int = promptNode.selectedOption

	promptNode.stop()

	return option

func onEffectRequirementsMet(effect: CardEffectData):
	if effect.hasCost() && effect.triggerEvent == CardEffectData.EffectTriggerEvent.SUMMON:
		var option = await prompt("Do you wish to activate the effect?")

		if option == 1:
			return

	startEffect(effect)

func startEffect(effect: CardEffectData):
	activatingEffect = true

	effectStarted.emit(effect)


func onPossibleTargetsSearch(effect: CardEffectData, targets: Array[CardData], amount):
	cardSelector.start(targets, amount, amount)

	await cardSelector.cardsSelected
	var selectedCards := cardSelector.selectedCards
	cardSelector.stop()

	executeEffect(effect, selectedCards)


func executeEffect(effect: CardEffectData, targets: Array[CardData] = []):
	match effect.type:
		CardEffectData.Type.DAMAGE:
			CardEffectSignals.damageEffect.emit(effect.source, targets, effect.typeParams.amount)
		CardEffectData.Type.GAIN_ELEMENTAL_ENERGY:
			CardEffectSignals.gainElementalEnergy.emit(
				effect.source.playerOwner,
				CardData.Archetype.get(effect.typeParams.energyType),
				effect.typeParams.amount
			)
			
	removeEffect(effect)
	chainEffect(effect)
	effectExecuted.emit(effect)

func chainEffect(effect: CardEffectData):
	for storedEffect in effects:
		storedEffect = storedEffect as CardEffectData

		if (
			storedEffect.triggerEvent
			== CardEffectData.EffectTriggerEvent.CHAIN
		):
			if storedEffect.triggerParams.has("playerOwner"):
				pass
			if storedEffect.triggerParams.target.has("triggerEffects"):
				var triggerEffects = storedEffect.triggerParams.target.triggerEffects
				if triggerEffects.has(
					CardEffectData.Type.find_key(effect.type)
				):
					effectAttempted.emit(storedEffect)
