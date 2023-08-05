extends TextureRect
class_name DeckContainer

@onready var inventory: CardInventoryComponent = $CardInventoryComponent
@onready var playerOwner: Player

var canDraw: bool = false
const FIRST_DRAW_AMOUNT: int = 3

signal clicked(deck: DeckContainer)
signal drawnCards(cardsDrawn: Array[CardNode])

func _ready():
	add_to_group("deck")
	for id in DeckManager.playerDeck:
		inventory.add(CardData.deserialize(id))

	for card in inventory.cards:
		card.location = CardFilter.CardLocation.DECK

	inventory.shuffle()

func firstDraw():
	drawCards(FIRST_DRAW_AMOUNT)

func drawCards(amount: int = 1):
	var cardsDrawn: Array[CardData] = []

	for i in amount:
		var card: CardData = inventory.cards.pop_front()
		if card != null:
			cardsDrawn.append(card)
	drawnCards.emit(cardsDrawn)
	canDraw = false

func onClick():
	if canDraw:
		drawCards(playerOwner.cardsToDraw)
