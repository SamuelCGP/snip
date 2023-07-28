extends TextureRect
class_name CardSlot

signal clicked(cardSlot: CardSlot)

@onready var inventory: CardInventoryComponent = $CardInventoryComponent
@export var types: Array[CardData.CardType]
var playerOwner: Player:
	set(value):
		playerOwner = value

		if initCardId:
			var card: CardNode = cardScene.instantiate() as CardNode
			card.cardData = CardData.deserialize(initCardId)
			card.playerOwner = value
			card.state = CardNode.CardState.SUMMONED
			get_parent().get_parent().placeCardAtSlot(card, self)

@export var initCardId: String
@export var cardScene: PackedScene

func onClick():
	clicked.emit(self)

func contains(card: CardNode) -> bool:
	return inventory.hasCard(card.cardData)

func removeCard(card: CardNode):
	inventory.remove(card.cardData)
	remove_child(card)

func addCard(card: CardNode):
	inventory.add(card.cardData)
	add_child(card)
	card.position = Vector2.ZERO
