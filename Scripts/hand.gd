extends Control
class_name Hand

@export var cardContainer: HBoxContainer
@export var inventory: CardInventoryComponent
@export var cardScene: PackedScene

signal clicked

var selectedCard: CardNode


func _ready():
	clicked.connect(onClick)
	Events.drawnCards.connect(onCardsDrawn)

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in 3:
		var cardIndex := rng.randi_range(0, DeckManager.playerDeck.size() - 1)
		var cardData := DeckManager.playerDeck[cardIndex]
		addCard(cardData)


func onClick():
	print("cricou")
	if selectCard:
		deselectCard()


func addCard(cardData: CardData):
	inventory.add(cardData)

	var cardNode = cardScene.instantiate() as CardNode
	cardNode.cardData = cardData

	cardNode.clicked.connect(selectCard)

	cardContainer.add_child(cardNode)


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


func onCardsDrawn(drawnCards: Array[CardData]):
	for card in drawnCards:
		addCard(card)


func _process(delta):
	pass
