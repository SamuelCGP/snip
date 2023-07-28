extends Control
class_name CardInventoryComponent

var cards: Array[CardData]

func hasCard(card: CardData) -> bool:
	if cards.find(card) != -1:
		return true

	return false

func isEmpty() -> bool:
	return cards.is_empty()

func shuffle():
	cards.shuffle()


func add(card: CardData):
	cards.push_back(card)


func remove(card: CardData):
	print(card.hp)
	print(cards[0].hp)
	assert(cards.find(card) != -1, "Card doesn't exist in inventory")
	cards.remove_at(cards.find(card))
