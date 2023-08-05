extends Node

var playerDeck: Array[String] = []

signal cardAdded(cardData: CardData)

func _ready():
	initializeDeck()

func addCard(card: CardData):
	playerDeck.append(card)
	cardAdded.emit(card)

func initializeDeck():
	playerDeck = [
		"C001",
		"C001",
		"C997",
		"C998",
		"C999",
		"M001"
	]
