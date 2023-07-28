extends Node

var playerDeck: Array[CardData] = []

signal cardAdded(cardData: CardData)


func _ready():
	initializeDeck()


func addCard(card: CardData):
	playerDeck.append(card)
	cardAdded.emit(card)


func initializeDeck():
	playerDeck = [
		CardData.deserialize("B001"),
		CardData.deserialize("B002"),
		CardData.deserialize("B003"),
		CardData.deserialize("B001"),
		CardData.deserialize("B002"),
		CardData.deserialize("B003"),
		CardData.deserialize("B001"),
		CardData.deserialize("B002"),
		CardData.deserialize("B003"),
		CardData.deserialize("B001"),
		CardData.deserialize("B002"),
		CardData.deserialize("B003")
	]
