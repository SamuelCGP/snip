class_name TurnStats

enum TurnPhase { DRAW, MAIN, END }

var turnPhaseOrder: Array[TurnPhase] = [TurnPhase.DRAW, TurnPhase.MAIN, TurnPhase.END]

var turnPlayer: Player:
	set(value):
		if turnPlayer:
			turnPlayer.isTurnPlayer = false

		turnPlayer = value
		value.isTurnPlayer = true

var turnNumber: int = 1
var playerTurnNumber: int = 1

var turnPhase: TurnPhase
var turnPhaseIndex: int = 0:
	set(index):
		turnPhaseIndex = index
		turnPhase = turnPhaseOrder[index]
