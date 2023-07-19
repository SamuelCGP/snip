extends Node2D
class_name Hand

@onready var cardContainer: Node2D = $CardContainer
@export var cardScene: PackedScene

var cards: Array[CardData] = []

func _ready():
	for i in 3:
		var rng = RandomNumberGenerator.new()
		rng.randomize()

		var cardIndex := rng.randi_range(0, Deck.playerDeck.size() - 1)
		var cardData := Deck.playerDeck[cardIndex]
		cards.append(cardData)

		var cardNode = cardScene.instantiate() as CardNode
		print(cardData)
		cardNode.cardData = cardData

		cardContainer.add_child(cardNode)
	
	print(cards)

func _process(delta):
	pass
