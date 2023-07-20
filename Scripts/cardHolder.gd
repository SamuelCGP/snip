extends TextureRect

signal clicked

var content: CardData

func removeCard(card: CardNode):
	content = null
	remove_child(card)


func addCard(card: CardNode):
	content = card.cardData
	add_child(card)
	card.position = Vector2.ZERO
