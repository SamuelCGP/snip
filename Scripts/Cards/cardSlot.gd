extends TextureRect
class_name CardSlot

signal clicked(cardSlot: CardSlot)

@export var types: Array[CardData.Function]

@onready var inventory: CardInventoryComponent = $CardInventoryComponent
@onready var container: CenterContainer = $CenterContainer

var playerOwner: Player:
	set(value):
		playerOwner = value

		if initCardId:
			var card: CardNode = cardScene.instantiate() as CardNode
			card.cardData = CardData.deserialize(initCardId)
			card.playerOwner = value
			card.state = CardNode.CardState.SUMMONED
			get_parent().get_parent().get_parent().placeCardAtSlot(card, self)

@export var initCardId: String
@export var cardScene: PackedScene

func _ready():
	add_to_group("cardSlot")

func getCard() -> CardNode:
	for child in container.get_children():
		if child.is_in_group("card"):
			return child

	return null

func onClick():
	clicked.emit(self)

func contains(card: CardNode) -> bool:
	return inventory.hasCard(card.cardData)

func removeCard(card: CardNode):
	inventory.remove(card.cardData)
	container.remove_child(card)

func addCard(card: CardNode):
	inventory.add(card.cardData)
	container.add_child(card)
	card.position = Vector2.ZERO
