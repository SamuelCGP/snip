extends TextureRect
class_name DeckContainer

@export var inventory: CardInventoryComponent
@export var boardSide: BoardSide
@onready var playerOwner = boardSide.playerOwner
var isEnabled: bool = false


func setEnabled(turnPlayer: TurnManager.Player, _turnNumber: int, turnPhase: TurnManager.TurnPhase):
	if !isEnabled:
		if turnPlayer == TurnManager.Player.ALLY && turnPhase == TurnManager.TurnPhase.DRAW:
			isEnabled = true
	else:
		if turnPlayer == TurnManager.Player.ENEMY || turnPhase != TurnManager.TurnPhase.DRAW:
			isEnabled = false


func _ready():
	inventory.cards = DeckManager.playerDeck
	if playerOwner == TurnManager.Player.ALLY:
		Events.newTurnPhase.connect(setEnabled)


func drawCards(amount: int = 1):
	var cardsDrawn: Array[CardData] = []

	for i in amount:
		var card: CardData = inventory.cards.pop_front()
		if card != null:
			cardsDrawn.push_back(card)

	Events.drawnCards.emit(cardsDrawn)


func onClick():
	if isEnabled:
		drawCards()
