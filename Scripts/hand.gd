extends Control
class_name Hand

@onready var cardContainer: HBoxContainer = $CardContainer
@export var cardScene: PackedScene

var cards: Array[CardData] = []

var selectedCard: CardNode:
	set(card):
		selectedCard = card

func removeCard(card: CardNode):
	if (selectedCard == card):
		selectedCard = null
	
	card.cardSelected = false
	cards.remove_at(cards.find(card.cardData))
	card.onClick.disconnect(selectCard)
	
	cardContainer.remove_child(card)

func _ready():
	for i in 3:
		var rng = RandomNumberGenerator.new()
		rng.randomize()

		var cardIndex := rng.randi_range(0, Deck.playerDeck.size() - 1)
		var cardData := Deck.playerDeck[cardIndex]
		cards.append(cardData)

		var cardNode = cardScene.instantiate() as CardNode
		cardNode.cardData = cardData

		cardNode.clicked.connect(selectCard)		
		cardNode.clickedOutside.connect(deselectCard)

		cardContainer.add_child(cardNode)
	
	print(cards)

func selectCard(card: CardNode):
	
	if(selectedCard):
		var oldCardId: String = selectedCard.cardData.id
		var cardId: String = card.cardData.id

		if(cardId == oldCardId): return

		deselectCard()
	
	card.cardSelected = true
	selectedCard = card
	pass

func deselectCard():
	if(selectedCard):
		selectedCard.cardSelected = false
		selectedCard = null

func _process(delta):
	pass
