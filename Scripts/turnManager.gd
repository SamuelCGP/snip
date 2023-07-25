extends Node
class_name TurnManager

enum Player { ALLY = 0, ENEMY = 1 }
enum TurnPhase { DRAW, SUMMON, BATTLE }

var playersData: Array[PlayerStats] = [PlayerStats.new(), PlayerStats.new()]

var currPlayerData: PlayerStats

var turnPlayer: Player:
	set(player):
		turnPlayer = player
		currPlayerData = playersData[player]

var turnNumber: int
var playerTurnNumber: int = 1

@export var turnPhaseOrder: Array[TurnPhase]
var turnPhase: TurnPhase
var turnPhaseIndex: int:
	set(index):
		turnPhaseIndex = index
		turnPhase = turnPhaseOrder[index]


func _ready():
	initialize()


func newTurn():
	for stats in playersData:
		stats.will = min(stats.will + stats.willPerTurn, stats.maxWill)

	Events.turnStarted.emit(turnPlayer, turnNumber)


func newPlayerTurn():
	turnPlayer = Player.ALLY if turnPlayer == Player.ENEMY else Player.ENEMY

	playerTurnNumber += 1

	turnPhaseIndex = 0

	if playerTurnNumber >= 2:
		newTurn()

	Events.playerTurnStarted.emit(turnPlayer, turnNumber)


func nextPhase():
	var newPhaseIndex = turnPhaseIndex + 1

	if newPhaseIndex >= turnPhaseOrder.size():
		newPlayerTurn()
	else:
		turnPhaseIndex = newPhaseIndex

	Events.newTurnPhase.emit(turnPlayer, turnNumber, turnPhase)

	var playerStr = "ENEMY" if turnPlayer == Player.ENEMY else "ALLY"
	var phaseStr: String

	match turnPhase:
		TurnPhase.DRAW:
			phaseStr = "DRAW"
		TurnPhase.BATTLE:
			phaseStr = "BATTLE"
		TurnPhase.SUMMON:
			phaseStr = "SUMMON"

	print("TURN: " + playerStr + " - " + phaseStr)


func initialize():
	turnPlayer = Player.ALLY
	turnNumber = 1
	turnPhaseIndex = 0

	Events.playerTurnStarted.emit(turnPlayer, turnNumber)
	Events.turnStarted.emit(turnPlayer, turnNumber)
	Events.newTurnPhase.emit(turnPlayer, turnNumber, turnPhase)


func setPlayerData(data: PlayerStats, player: Player = turnPlayer):
	playersData[player] = data
	pass


func _on_end_turn_button_down():
	nextPhase()
