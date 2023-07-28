extends Control
class_name CardInventoryComponent

var cards: Array[CardData]


func isEmpty() -> bool:
	return cards.is_empty()


func shuffle():
	cards.shuffle()


func add(card: CardData):
	cards.push_back(card)


func remove(card: CardData):
	cards.remove_at(cards.find(card))
