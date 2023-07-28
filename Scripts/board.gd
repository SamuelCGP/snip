extends Control
class_name Board

signal battleCardsSelected(attacker: CardNode, target: CardNode)
@onready var boardSides: Array[BoardSide] = [$AllySide, $EnemySide]

var selectedCard: CardNode:
	set(value):
		if selectedCard:
			selectedCard.cardSelected = false

		selectedCard = value

		if selectedCard:
			selectedCard.cardSelected = true

var attackerCard: CardNode
var targetCard: CardNode

var canBattle: bool = false:
	set(value):
		canBattle = value
		for card in get_tree().get_nodes_in_group("card"):
			card = card as CardNode
			setCardCanBattle(card, value)

func _ready():
	for side in boardSides:
		side.cardPlaced.connect(onCardPlace)

func setSideOwners(players: Dictionary):
	for id in PlayerManager.PlayerID:
		var index: int = PlayerManager.PlayerID[id]
		boardSides[index].playerOwner = players[index]

func setCardCanBattle(card: CardNode, value: bool):
	if card.state == CardNode.CardState.SUMMONED:
		if card.playerOwner.isTurnPlayer:
			if card.cardData.attack:
				card.canAttack = value
		else:
			if card.find_child("HPComponent"):
				card.canBeTargeted = value

func startBattle():
	var hpComponent: HPComponent = targetCard.get_node("HPComponent")
	hpComponent.damage(attackerCard.cardData.attack)

	targetCard = null

	attackerCard.canAttack = false
	attackerCard = null
	selectedCard = null

func onCardClick(card: CardNode):

	if card.playerOwner.id == PlayerManager.PlayerID.ALLY:
		selectedCard = card
	elif attackerCard && !targetCard && card.canBeTargeted:
		targetCard = card
		print(targetCard)
		startBattle()

func onAttackAttempt(card: CardNode):
	if card.playerOwner.isTurnPlayer && card.canAttack:
		attackerCard = card


func onCardDestroyed(card: CardNode):
	card.clicked.disconnect(onCardClick)
	var boardSide: BoardSide = boardSides[card.playerOwner.id]
	boardSide.sendToGraveyard(card)

func onCardPlace(card: CardNode):
	print("card placed")
	card.clicked.connect(onCardClick)
	card.attackAttempted.connect(onAttackAttempt)
	card.destroyed.connect(onCardDestroyed)

	setCardCanBattle(card, true)
