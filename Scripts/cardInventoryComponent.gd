extends Control
class_name CardInventoryComponent

var cards: Array[CardData]

func shuffle():
	cards.shuffle()

func add(card: CardData):
	cards.push_back(card)

func remove(card: CardData):
	cards.remove_at(cards.find(card))