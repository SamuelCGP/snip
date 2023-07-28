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
			addCard(card)
			card.state = CardNode.CardState.SUMMONED

@export var initCardId: String
@export var cardScene: PackedScene

func onClick():
	clicked.emit(self)

func removeCard(card: CardNode):
	inventory.remove(card.cardData)
	remove_child(card)


func addCard(card: CardNode):
	inventory.add(card.cardData)
	add_child(card)
	card.position = Vector2.ZERO
