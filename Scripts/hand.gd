extends Control
class_name Hand

@onready var cardContainer: HBoxContainer = $CardContainer
@onready var inventory: CardInventoryComponent = $CardInventoryComponent

@export_category("Card Scenes")
@export var monsterCard: PackedScene
@export var mageCard: PackedScene
@export var prophecyCard: PackedScene
@export var spellCard: PackedScene

@onready var cardScenes = {
	MONSTER = monsterCard
}

var playerOwner: Player:
	set(value):
		playerOwner = value
		if value.id == PlayerManager.PlayerID.ALLY:
			clicked.connect(onClick)


signal clicked(hand: Hand)
signal summonAttempted(hand: Hand, card: CardNode)

var selectedCard: CardNode:
	set(value):
		if selectedCard:
			selectedCard.cardSelected = false

		selectedCard = value
		if selectedCard:
			selectedCard.cardSelected = true

func setOwner(player: Player):
	playerOwner = player

func onClick():
	if selectCard:
		deselectCard()

func _process(_delta):
	if selectedCard:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var mousePos: Vector2 = get_viewport().get_mouse_position()
			if !cardContainer.get_global_rect().has_point(mousePos):
				deselectCard()

func onSummonAttempt(
	card: CardNode,
):
	if cardContainer.get_children().has(card):
		summonAttempted.emit(card)


func addCard(cardData: CardData):
	inventory.add(cardData)

	if playerOwner.id == PlayerManager.PlayerID.ALLY:
		var cardNode = cardScenes[CardData.CardType.keys()[cardData.cardType]].instantiate() as CardNode
		cardNode.cardData = cardData

		if playerOwner.id == PlayerManager.PlayerID.ALLY:
			cardNode.clicked.connect(selectCard)

		cardContainer.add_child(cardNode)
		cardNode.playerOwner = playerOwner
		cardNode.summonAttempted.connect(onSummonAttempt)


func removeCard(card: CardNode):
	if selectedCard == card:
		selectedCard = null

	inventory.remove(card.cardData)

	card.clicked.disconnect(selectCard)

	cardContainer.remove_child(card)


func selectCard(card: CardNode):
	if selectedCard:
		if card == selectedCard:
			return

		deselectCard()

	selectedCard = card


func deselectCard():
	if selectedCard:
		selectedCard.cardSelected = false


func onCardsDraw(drawnCards: Array[CardData]):
	for card in drawnCards:
		addCard(card)
