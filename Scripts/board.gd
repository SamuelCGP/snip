extends Control
class_name Board

signal battleCardsSelected(attacker: CardNode, target: CardNode)
@onready var boardSides: Array[BoardSide] = [$AllySide, $EnemySide]
@onready var decks: Array[DeckContainer]= [boardSides[0].deck, boardSides[1].deck]

var attackerCard: CardNode
var targetCard: CardNode

func connectSignals():
	CardEffectSignals.damageEffect.connect(onDamageEffect)
	for side in boardSides:
		side.cardPlaced.connect(onCardPlace)

var canBattle: bool = false:
	set(value):
		canBattle = value
		for card in get_tree().get_nodes_in_group("card"):
			card = card as CardNode
			setCardCanBattle(card, value)

func _ready():
	connectSignals()

func onDamageEffect(source: CardNode, targets: Array[CardData], amount: int):
	for target in targets:
		target = target as CardData

		for side in boardSides:
			side = side as BoardSide

			var result = side.searchCardByData(target)
			if result:
				damageCard(result, amount)
				break


func setOwners(players: Dictionary):
	for id in PlayerManager.PlayerID.values():
		boardSides[id].playerOwner = players[id]

func setCardCanBattle(card: CardNode, value: bool):
	if card.state == CardNode.CardState.SUMMONED && card.cardData.function == CardData.Function.CREATURE:
		if card.playerOwner.isTurnPlayer:
			if card.cardData.attack:
				card.canAttack = value
		else:
			if card.find_child("HPComponent"):
				card.canBeTargeted = value

func onMainPhaseStarted():
	for card in get_tree().get_nodes_in_group("card"):
		card = card as CardNode
		setCardCanBattle(card, true)

func startBattle():
	damageCard(targetCard, attackerCard.cardData.attack)

	targetCard = null

	attackerCard.canAttack = false
	attackerCard = null
	
	if Global.selectedCard == attackerCard:
		Global.selectedCard = null

func damageCard(target: CardNode, amount: int):
	var hpComponent: HPComponent = target.get_node("HPComponent")
	hpComponent.damage(amount)

func onCardClick(card: CardNode):
	if card.playerOwner.id != PlayerManager.PlayerID.ALLY && attackerCard && !targetCard && card.canBeTargeted:
		targetCard = card
		startBattle()

func onAttackAttempt(card: CardNode):
	if card.playerOwner.isTurnPlayer && card.canAttack:
		attackerCard = card

func onCardDestroyed(card: CardNode):
	card.clicked.disconnect(onCardClick)
	var boardSide: BoardSide = boardSides[card.playerOwner.id]
	boardSide.sendToGraveyard(card)

func onCardPlace(card: CardNode):
	card.clicked.connect(onCardClick)
	card.attackAttempted.connect(onAttackAttempt)
	card.destroyed.connect(onCardDestroyed)
	
	if card.cardData.function == CardData.Function.CREATURE:
		var cardData = card.cardData as CreatureCardData
		if cardData.sigils.has(CreatureCardData.Sigil.HASTE):
			setCardCanBattle(card, true)
