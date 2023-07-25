extends TextureRect
class_name CardHolder

signal clicked(cardHolder: CardHolder)

@export var inventory: CardInventoryComponent
@export var types: Array[CardData.CardType]
@export var boardSide: BoardSide
@onready var playerOwner = boardSide.playerOwner
var isEnabled: bool = false

var content: CardData


func _ready():
	if playerOwner == TurnManager.Player.ALLY:
		Events.newTurnPhase.connect(setEnabled)


func setEnabled(turnPlayer: TurnManager.Player, _turnNumber: int, turnPhase: TurnManager.TurnPhase):
	if !isEnabled:
		if turnPlayer == TurnManager.Player.ALLY && turnPhase == TurnManager.TurnPhase.SUMMON:
			isEnabled = true
	else:
		if turnPlayer == TurnManager.Player.ENEMY || turnPhase != TurnManager.TurnPhase.SUMMON:
			isEnabled = false


func onClick():
	clicked.emit(self)


func removeCard(card: CardNode):
	inventory.remove(card.cardData)
	remove_child(card)


func addCard(card: CardNode):
	inventory.add(card.cardData)
	add_child(card)
	card.position = Vector2.ZERO
