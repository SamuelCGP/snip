extends Control
class_name BoardSide

@onready var summonedCardsInv: CardInventoryComponent = $CardInventoryComponent
@onready var deck: DeckContainer = $VBoxContainer/BackRow/Deck
@onready var graveyard: Graveyard = $VBoxContainer/BackRow/Graveyard
@onready var cardSlots: Array[Node] = getSlots()

func getSlots() -> Array[Node]:
	var slots: Array[Node] = []

	for row in $VBoxContainer.get_children():
		for child in row.get_children():
			if child.is_in_group("cardSlot"):
				slots.append(child as Node)

	return slots
				

@export var mageCard: PackedScene

signal summonTargetSet(card: CardNode, target: CardSlot, boardSide: BoardSide)
signal cardPlaced(card: CardNode, slot: CardSlot, boardSide: BoardSide)
signal mageSummoned(card: CardNode)

var summoningCard: CardNode = null

var playerOwner: Player:
	set(value):
		playerOwner = value

		for slot in cardSlots:
			slot = slot as CardSlot
			slot.playerOwner = value
	
		deck.playerOwner = value

func searchCardByData(cardData: CardData) -> CardNode:
	for slot in cardSlots:
		slot = slot as CardSlot
		if slot.inventory.hasCard(cardData):
			return slot.getCard()

	return null

func summonMage():
	var filter: CardFilter = CardFilter.new()
	filter.function = CardData.Function.MAGE
	var mage: CardData = deck.inventory.searchCards(filter)[0]
	deck.inventory.remove(mage)
	var mageNode: CardNode = Hand.instantiateCard(mage, mageCard)
	mageNode.playerOwner = playerOwner

	var mageSlot: CardSlot

	for slot in cardSlots:
		slot = slot as CardSlot
		if slot.types.has(CardData.Function.MAGE):
			mageSlot = slot
			break

	mageNode.state = CardNode.CardState.SUMMONED
	placeCardAtSlot(mageNode, mageSlot)
	mageSummoned.emit(mageNode)

func hasSummonedCards() -> bool:
	return !summonedCardsInv.isEmpty()

func _ready():
	for slot in cardSlots:
		slot = slot as CardSlot

		slot.clicked.connect(onCardSlotClick)

func onCardSlotClick(cardSlot: CardSlot):
	if summoningCard:
		if cardSlot.inventory.isEmpty() && cardSlot.types.has(summoningCard.cardData.function):
			summonTargetSet.emit(summoningCard, cardSlot, self)
			summoningCard = null

func onSummonAttempt(card: CardNode):
	summoningCard = card

func placeCardAtSlot(card: CardNode, cardSlot: CardSlot):
	summonedCardsInv.add(card.cardData)
	cardSlot.addCard(card)
	cardPlaced.emit(card)

func removeCardFromBoard(card: CardNode):
	for slot in cardSlots:
		slot = slot as CardSlot
		if slot.contains(card):
			slot.removeCard(card)

	summonedCardsInv.remove(card.cardData)

func sendToGraveyard(card: CardNode):
	card.state = CardNode.CardState.IN_GRAVEYARD

	removeCardFromBoard(card)
	graveyard.addCard(card)
