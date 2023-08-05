extends Control
class_name HPComponent

@onready var card: CardNode = get_parent()

func damage(amount: int):
	card.cardData.hp -= amount
	if card.cardData.hp <= 0:
		card.destroyed.emit(card)
