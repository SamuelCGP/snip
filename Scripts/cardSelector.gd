extends CenterContainer
class_name CardSelector

signal cardsSelected

@export var uiCardScene: PackedScene
@export var locationContainerScene: PackedScene

@onready var resultsContainer = %ResultsContainer

var selectedCards: Array[CardData]
var minCards: int
var maxCards: int

func start(cards: Array[CardData], maxAmount: int, minAmount: int = 1):
	visible = true
	minCards = minAmount
	maxCards = maxAmount
	renderCards(cards)


func stop():
	visible = false
	minCards = 0
	maxCards = 0
	
	for child in resultsContainer.get_children():
		resultsContainer.remove_child(child)
		child.queue_free()

	selectedCards = []


func renderCards(cards: Array[CardData]):
	var locationContainers: Dictionary = {}

	for card in cards:
		card = card as CardData

		if !locationContainers.get(card.location):
			var locationContainer = locationContainerScene.instantiate()
			resultsContainer.add_child(locationContainer)

			var label: Label = locationContainer.get_node("%ContainerLabel")
			label.text = CardFilter.CardLocation.find_key(card.location)

			locationContainers[card.location] = locationContainer

		var cardInstance = uiCardScene.instantiate() as UICard

		locationContainers[card.location].get_node("%CardContainer").add_child(cardInstance)
		cardInstance.initialize(card)
		cardInstance.clicked.connect(onCardClick)

func onCardClick(card: UICard):
	if !card.selected:
		if maxCards && selectedCards.size() >= maxCards:
			return

		selectCard(card)
	else:
		deselectCard(card)


func selectCard(card: UICard):
	card.selected = true
	selectedCards.append(card.cardData)


func deselectCard(card: UICard):
	card.selected = false
	selectedCards.erase(card.cardData)


func _on_confirm_button_down():
	if minCards && selectedCards.size() < minCards:
		return

	cardsSelected.emit(selectedCards)
