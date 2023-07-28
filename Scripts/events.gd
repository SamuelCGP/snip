extends Node

signal playerTurnStarted(turnStats: TurnStats)
signal newTurnPhase(turnStats)

signal cardHolderClicked(cardSlot: CardSlot)
signal cardSummoned(card: CardNode, cardSlot: CardSlot, turnStats: TurnStats)
