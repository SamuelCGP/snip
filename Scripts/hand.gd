extends Control
class_name Hand

signal cardAdded

@onready var cardContainer: HBoxContainer = $CardContainer
@onready var inventory: CardInventoryComponent = $CardInventoryComponent

@export_category("Card Scenes")
@export var creatureCard: PackedScene
@export var mageCard: PackedScene
@export var prophecyCard: PackedScene
@export var spellCard: PackedScene

@onready var cardScenes = {CREATURE = creatureCard}

var playerOwner: Player

signal clicked(hand: Hand)
signal summonAttempted(hand: Hand, card: CardNode)


func setOwner(player: Player):
	playerOwner = player


func onSummonAttempt(
	card: CardNode,
):
	if cardContainer.get_children().has(card):
		summonAttempted.emit(card)


func searchCardByData(cardData: CardData) -> CardNode:
	for child in cardContainer.get_children():
		if child.is_in_group("card"):
			var card = child as CardNode
			if card.cardData == cardData:
				return card

	return null


static func instantiateCard(cardData: CardData, scene: PackedScene) -> CardNode:
	var cardNode = scene.instantiate() as CardNode
	cardNode.cardData = cardData
	return cardNode


func addCard(cardData: CardData):
	inventory.add(cardData)

	if playerOwner.id == PlayerManager.PlayerID.ALLY:
		var cardNode = Hand.instantiateCard(
			cardData, cardScenes[CardData.Function.find_key(cardData.function)]
		)

		cardContainer.add_child(cardNode)
		cardNode.playerOwner = playerOwner
		cardNode.summonAttempted.connect(onSummonAttempt)
		cardAdded.emit(cardNode)


func removeCard(card: CardNode):
	if Global.selectedCard == card:
		Global.selectedCard = null

	inventory.remove(card.cardData)

	cardContainer.remove_child(card)


func onCardsDraw(drawnCards: Array[CardData]):
	for card in drawnCards:
		addCard(card)
