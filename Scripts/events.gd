extends Node

signal playerTurnStarted(turnStats: TurnStats)
signal newTurnPhase(turnStats)

signal cardHolderClicked(cardHolder: CardHolder)
signal cardSummoned(card: CardNode, cardHolder: CardHolder, turnStats: TurnStats)
