extends Control
class_name Hand

@onready var cardContainer: HBoxContainer = $CardContainer
@onready var inventory: CardInventoryComponent = $CardInventoryComponent
@export var cardScene: PackedScene
var playerOwner: Player:
	set(value):
		playerOwner = value
		if value.id == PlayerManager.PlayerID.ALLY:
			clicked.connect(onClick)


signal clicked(hand: Hand)
signal summonAttempted(hand: Hand, card: CardNode)

var selectedCard: CardNode

func setOwner(player: Player):
	playerOwner = player

func onClick():
	if selectCard:
		deselectCard()

func onSummonAttempt(
	card: CardNode,
):
	if cardContainer.get_children().has(card):
		summonAttempted.emit(card)


func addCard(cardData: CardData):
	inventory.add(cardData)

	if playerOwner.id == PlayerManager.PlayerID.ALLY:
		var cardNode = cardScene.instantiate() as CardNode
		cardNode.cardData = cardData

		if playerOwner.id == PlayerManager.PlayerID.ALLY:
			cardNode.clicked.connect(selectCard)

		cardContainer.add_child(cardNode)
		cardNode.playerOwner = playerOwner
		cardNode.summonAttempted.connect(onSummonAttempt)


func removeCard(card: CardNode):
	if selectedCard == card:
		selectedCard = null
		card.cardSelected = false

	inventory.remove(card.cardData)

	card.clicked.disconnect(selectCard)

	cardContainer.remove_child(card)


func selectCard(card: CardNode):
	if selectedCard:
		if card == selectedCard:
			return

		deselectCard()

	card.cardSelected = true
	selectedCard = card


func deselectCard():
	if selectedCard:
		selectedCard.cardSelected = false
		selectedCard = null


func onCardsDraw(drawnCards: Array[CardData]):
	for card in drawnCards:
		addCard(card)
