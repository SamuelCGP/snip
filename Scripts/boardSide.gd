extends Control
class_name BoardSide

@onready var summonedCardsInv: CardInventoryComponent = $CardInventoryComponent
@onready var cardHolderContainer: Control = $CardHolderContainer
@onready var deck: DeckContainer = $Deck

signal summonTargetSet(card: CardNode, target: CardSlot, boardSide: BoardSide)
signal cardPlaced(card: CardNode, slot: CardSlot, boardSide: BoardSide)

var summoningCard: CardNode = null

var playerOwner: Player:
	set(value):
		playerOwner = value

		for slot in cardHolderContainer.get_children():
			slot = slot as CardSlot
			slot.playerOwner = value
	
		deck.playerOwner = value

func setHoldersOwner():
	for slot in cardHolderContainer.get_children():
		slot = slot as CardSlot
		slot.playerOwner = playerOwner
	
	deck.playerOwner = playerOwner

func hasSummonedCards() -> bool:
	return !summonedCardsInv.isEmpty()

func _ready():
	for cardSlot in cardHolderContainer.get_children():
		cardSlot = cardSlot as CardSlot

		cardSlot.clicked.connect(onCardHolderClick)

func onCardHolderClick(cardSlot: CardSlot):
	if summoningCard:
		if cardSlot.inventory.isEmpty() && cardSlot.types.has(summoningCard.cardData.cardType):
			summonTargetSet.emit(summoningCard, cardSlot, self)
			summoningCard = null

func onSummonAttempt(card: CardNode):
	summoningCard = card

func placeCardAtHolder(card: CardNode, cardSlot: CardSlot):
	cardSlot.addCard(card)
	cardPlaced.emit(card, cardSlot, self)