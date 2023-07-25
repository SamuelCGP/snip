extends Control
class_name Board

@export var playerHand: Hand
@export var cardHolderContainer: Control
@export var turnManager: TurnManager


# Called when the node enters the scene tree for the first time.
func _ready():
	for cardHolder in cardHolderContainer.get_children():
		cardHolder = cardHolder as CardHolder
		cardHolder.clicked.connect(placeCardAtHolder)


func placeCardAtHolder(cardHolder: CardHolder, withCost: bool = true, _normalSummon: bool = true):
	if !cardHolder.isEnabled:
		return

	var selectedCard: CardNode = playerHand.selectedCard
	var playerData := turnManager.currPlayerData

	if selectedCard && !cardHolder.content:
		if !cardHolder.types.has(selectedCard.cardData.cardType):
			return

		if withCost && selectedCard.cardData.willCost:
			if selectedCard.cardData.willCost > playerData.will:
				return

			playerData.will -= selectedCard.cardData.willCost

		playerHand.removeCard(selectedCard)
		cardHolder.addCard(selectedCard)


func fromBoardToGraveyard(card: CardNode):
	for cardHolder in cardHolderContainer.get_children():
		cardHolder = cardHolder as CardHolder

		#TODO terminar, pra isso preciso fazer o combate e testar efeitos de cartas que mandam pro cemiterio
