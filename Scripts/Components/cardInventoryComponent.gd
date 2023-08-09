extends Control
class_name CardInventoryComponent

var cards: Array[CardData]

func searchCards(filter: CardFilter) -> Array[CardData]:
	var result: Array[CardData] = []
	
	for card in cards:
		card = card as CardData

		if CardFilter.validateFilter(card, filter):
			result.append(card)

	return result


func hasCard(card: CardData) -> bool:
	for item in cards:
		item = item as CardData
		if item.get_instance_id() == card.get_instance_id():
			return true

	return false


func isEmpty() -> bool:
	return cards.is_empty()


func shuffle():
	cards.shuffle()


func add(card: CardData):
	cards.append(card)


func remove(card: CardData):
	assert(cards.find(card) != -1, "Card doesn't exist in inventory")
	cards.erase(card)
