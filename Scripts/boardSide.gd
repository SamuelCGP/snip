extends Control
class_name BoardSide

@onready var summonedCardsInv: CardInventoryComponent = $CardInventoryComponent
@onready var cardSlotContainer: Control = $CardSlotContainer
@onready var deck: DeckContainer = $Deck
@onready var graveyard: Graveyard = $Graveyard

signal summonTargetSet(card: CardNode, target: CardSlot, boardSide: BoardSide)
signal cardPlaced(card: CardNode, slot: CardSlot, boardSide: BoardSide)

var summoningCard: CardNode = null

var playerOwner: Player:
	set(value):
		playerOwner = value

		for slot in cardSlotContainer.get_children():
			slot = slot as CardSlot
			slot.playerOwner = value
	
		deck.playerOwner = value

func setHoldersOwner():
	for slot in cardSlotContainer.get_children():
		slot = slot as CardSlot
		slot.playerOwner = playerOwner
	
	deck.playerOwner = playerOwner

func hasSummonedCards() -> bool:
	return !summonedCardsInv.isEmpty()

func _ready():
	for cardSlot in cardSlotContainer.get_children():
		cardSlot = cardSlot as CardSlot

		cardSlot.clicked.connect(onCardSlotClick)

func onCardSlotClick(cardSlot: CardSlot):
	if summoningCard:
		if cardSlot.inventory.isEmpty() && cardSlot.types.has(summoningCard.cardData.cardType):
			summonTargetSet.emit(summoningCard, cardSlot, self)
			summoningCard = null

func onSummonAttempt(card: CardNode):
	summoningCard = card

func placeCardAtSlot(card: CardNode, cardSlot: CardSlot):
	summonedCardsInv.add(card.cardData)
	cardSlot.addCard(card)
	cardPlaced.emit(card)

func removeCardFromBoard(card: CardNode):
	for cardSlot in cardSlotContainer.get_children():
		cardSlot = cardSlot as CardSlot
		if cardSlot.contains(card):
			print("contains")
			cardSlot.removeCard(card)

	summonedCardsInv.remove(card.cardData)

func sendToGraveyard(card: CardNode):
	card.state = CardNode.CardState.IN_GRAVEYARD

	removeCardFromBoard(card)
	graveyard.addCard(card)
