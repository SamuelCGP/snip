extends TextureRect
class_name Graveyard

@onready var inventory: CardInventoryComponent = $CardInventoryComponent
@onready var container: CenterContainer = $CenterContainer

func removeCard(card: CardNode):
	inventory.remove(card.cardData)
	container.remove_child(card)

func searchCardByData(cardData: CardData) -> CardNode:
	for child in get_children():
		if child.is_in_group("card"):
			var card = child as CardNode
			if card.cardData == cardData:
				return card
	
	return null

func addCard(card: CardNode):
	inventory.add(card.cardData)
	container.add_child(card)
	card.position = Vector2.ZERO
