class_name Player

var id: PlayerManager.PlayerID
var will: int = 1
var willPerTurn: int = 1
var maxWill: int = 10
var cardsToDraw: int = 1
var isTurnPlayer: bool = false
var energy: Dictionary = {
	"SPIRIT": 10,
	"NATURE": 10
}

func _init(playerId):
	id = playerId
