extends Control
class_name BoardSide

@onready var summonedCardsInv: CardInventoryComponent = $CardInventoryComponent
@onready var cardHolderContainer: Control = $CardHolderContainer
@onready var deck: DeckContainer = $Deck

signal summonTargetSet(card: CardNode, target: CardHolder, boardSide: BoardSide)

var summoningCard: CardNode = null

var playerOwner: Player:
	set(value):
		playerOwner = value

		for holder in cardHolderContainer.get_children():
			holder = holder as CardHolder
			holder.playerOwner = value
	
		deck.playerOwner = value

func setHoldersOwner():
	for holder in cardHolderContainer.get_children():
		holder = holder as CardHolder
		holder.playerOwner = playerOwner
	
	deck.playerOwner = playerOwner

func hasSummonedCards() -> bool:
	return !summonedCardsInv.isEmpty()

func _ready():
	for cardHolder in cardHolderContainer.get_children():
		cardHolder = cardHolder as CardHolder

		cardHolder.clicked.connect(onCardHolderClick)

func onCardHolderClick(cardHolder: CardHolder):
	if summoningCard:
		if cardHolder.inventory.isEmpty() && cardHolder.types.has(summoningCard.cardData.cardType):
			summonTargetSet.emit(summoningCard, cardHolder, self)
			summoningCard = null

func onSummonAttempt(card: CardNode):
	summoningCard = card

func placeCardAtHolder(card: CardNode, cardHolder: CardHolder):
	cardHolder.addCard(card)