extends TextureRect
class_name Graveyard

@onready var inventory: CardInventoryComponent = $CardInventoryComponent

func removeCard(card: CardNode):
	inventory.remove(card.cardData)
	remove_child(card)

func addCard(card: CardNode):
	inventory.add(card.cardData)
	add_child(card)
	card.position = Vector2.ZERO
