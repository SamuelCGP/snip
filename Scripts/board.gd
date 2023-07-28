extends Control
class_name Board

@onready var boardSides: Array[BoardSide] = [$AllySide, $EnemySide]

var targetCard: CardNode
var attackerCard: CardNode

var canBattle: bool = false

func _ready():
	for side in boardSides:
		side.cardPlaced.connect(onCardPlace)

func setSideOwners(players: Dictionary):
	for id in PlayerManager.PlayerID:
		var index: int = PlayerManager.PlayerID[id]
		boardSides[index].playerOwner = players[index]

func onCardPlace(card: CardNode, slot: CardSlot, boardSide: BoardSide):
	pass
