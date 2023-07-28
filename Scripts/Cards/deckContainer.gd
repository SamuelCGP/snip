extends TextureRect
class_name DeckContainer

@onready var inventory: CardInventoryComponent = $CardInventoryComponent
@onready var playerOwner: Player

var canDraw: bool = false

signal clicked(deck: DeckContainer)
signal drawnCards(cardsDrawn: Array[CardNode])

func _ready():
	add_to_group("deck")
	inventory.cards = DeckManager.playerDeck

func drawCards(amount: int = 1):
	var cardsDrawn: Array[CardData] = []

	for i in amount:
		var card: CardData = inventory.cards.pop_front()
		if card != null:
			cardsDrawn.push_back(card)

	drawnCards.emit(cardsDrawn)
	canDraw = false

func onClick():
	if canDraw:
		drawCards(playerOwner.cardsToDraw)
