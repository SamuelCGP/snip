extends Control
class_name EffectManager

signal effectStarted(effect: CardEffectData)
signal effectAttempted(effect: CardEffectData)

@onready var cardSelector: CardSelector = $CardSelector

var playerOwner: Player
var effects: Array[CardEffectData]
var parentCard: CardNode
var activatingEffect: bool

func addEffect(effect: CardEffectData):
	effects.append(effect)

func removeEffect(effect: CardEffectData):
	effects.erase(effect)

func setOwner(player: Player):
	playerOwner = player

func onCardAddedToHand(card: CardNode):
	for effect in card.cardData.effects:
		effect.source = card
		addEffect(effect)

func onCardSummon(card: CardNode):
	for effect in effects:
		effect = effect as CardEffectData
		if card == effect.source:
			if(effect.triggerEvent == CardEffectData.EffectTriggerEvent.SUMMON):
				if effect.triggerParams.target[0].isSelf && effect.source != card:
					return

				if !CardFilter.validateFilter(card.cardData, CardFilter.deserialize(effect.triggerParams.target)[0]):
					return
				
				effectAttempted.emit(effect)

func onEffectRequirementsMet(effect: CardEffectData):
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

func executeEffect(effect: CardEffectData, targets: Array[CardData]):
	match(effect.type):
		CardEffectData.Type.DAMAGE:
			CardEffectSignals.damageEffect.emit(effect.source, targets, effect.typeParams.amount)
