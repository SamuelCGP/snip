extends Node

var playerDeck: Array[CardData] = []

signal cardAdded(cardData: CardData)

func _ready():
	initializeDeck()

func addCard(card: CardData):
	playerDeck.append(card)
	emit_signal("cardAdded", card)

func initializeDeck():
	playerDeck = [CardData.deserialize("B001"), CardData.deserialize("B002"), CardData.deserialize("B003")]
	print(playerDeck)