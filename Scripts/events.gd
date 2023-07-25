extends Node

signal drawnCards(cards: CardData)
signal turnStarted(turnPlayer: TurnManager.Player, turnNumber: int)
signal playerTurnStarted(turnPlayer: TurnManager.Player, turnNumber: int)
signal newTurnPhase(
	turnPlayer: TurnManager.Player, turnNumber: int, turnPhase: TurnManager.TurnPhase
)
