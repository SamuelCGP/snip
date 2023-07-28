extends Control
class_name Board

@onready var boardSides: Array[BoardSide] = [$AllySide, $EnemySide]

func setSideOwners(players: Dictionary):
	for id in PlayerManager.PlayerID:
		var index: int = PlayerManager.PlayerID[id]
		boardSides[index].playerOwner = players[index]
