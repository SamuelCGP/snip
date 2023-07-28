extends Control
class_name MatchManager

@onready var playerManager: PlayerManager = $PlayerManager
@onready var board: Board = $Board
@onready var hands: Array[Hand] = [$AllyHand, $EnemyHand]
@onready var decks: Array[DeckContainer] = [board.get_node("AllySide/Deck"), board.get_node("EnemySide/Deck")]

var turnStats: TurnStats = TurnStats.new()

func _ready():
	turnStats.turnPlayer = playerManager.players[PlayerManager.PlayerID.ALLY]

	board.setSideOwners(playerManager.players)
	for boardSide in board.boardSides:
		boardSide = boardSide as BoardSide
		boardSide.summonTargetSet.connect(onSummonTargetSet)

	for id in PlayerManager.PlayerID:
		var index: int = PlayerManager.PlayerID[id]
		hands[index].setOwner(playerManager.players[index])
		hands[index].summonAttempted.connect(onSummonAttempt)

		var rng = RandomNumberGenerator.new()
		rng.randomize()

		for i in 3:
			var cardIndex := rng.randi_range(0, DeckManager.playerDeck.size() - 1)
			var cardData := DeckManager.playerDeck[cardIndex]
			hands[index].addCard(cardData)

		decks[index].drawnCards.connect(hands[index].onCardsDraw)

	playerManager.willChanged.connect(onWillChanged)
	startDrawPhase()

func onSummonTargetSet(card: CardNode, target: CardSlot, boardSide: BoardSide):
	hands[card.playerOwner.id].removeCard(card)
	boardSide.placeCardAtHolder(card, target)
	card.state = CardNode.CardState.SUMMONED
	playerManager.onCardSummon(card)

func onSummonAttempt(card: CardNode):
	var boardSide: BoardSide = board.boardSides[card.playerOwner.id]
	boardSide.onSummonAttempt(card)

func verifyCardCanSummon(card: CardNode):
	if turnStats.turnPlayer.id == card.playerOwner.id:
		if card.state == CardNode.CardState.IN_HAND:
			if !card.cardData.willCost:
				card.canSummon = true
			elif card.cardData.willCost <= card.playerOwner.will:
				card.canSummon = true
			else:
				card.canSummon = false
		else:
			card.canSummon = false


func onWillChanged(_player: Player):
	for card in get_tree().get_nodes_in_group("card"):
		card = card as CardNode
		if turnStats.turnPhase == TurnStats.TurnPhase.MAIN:
			verifyCardCanSummon(card)
		else:
			card.canSummon = false

func newTurn():
	playerManager.onTurnStarted(turnStats)

func newPlayerTurn():
	turnStats.turnPlayer = (
		playerManager.players[PlayerManager.PlayerID.ALLY]
		if turnStats.turnPlayer == playerManager.players[PlayerManager.PlayerID.ENEMY]
		else playerManager.players[PlayerManager.PlayerID.ENEMY]
	)

	turnStats.playerTurnNumber += 1

	turnStats.turnPhaseIndex = 0

	if turnStats.playerTurnNumber >= 2:
		newTurn()

func startMainPhase():
	board.canBattle = true
	for card in get_tree().get_nodes_in_group("card"):
		card = card as CardNode
		verifyCardCanSummon(card)

func endMainPhase():
	board.canBattle = false
	for card in get_tree().get_nodes_in_group("card"):
		card = card as CardNode
		card.canSummon = false

func setDeckCanDraw(value: bool):
	for deck in get_tree().get_nodes_in_group("deck"):
		deck = deck as DeckContainer
		if deck.playerOwner.id == turnStats.turnPlayer.id:
			deck.canDraw = value

func startDrawPhase():
	setDeckCanDraw(true)

func endDrawPhase():
	setDeckCanDraw(false)

func nextPhase():
	match turnStats.turnPhase:
		TurnStats.TurnPhase.DRAW:
			endDrawPhase()
		TurnStats.TurnPhase.MAIN:
			endMainPhase()
		TurnStats.TurnPhase.END:
			pass

	var newPhaseIndex = turnStats.turnPhaseIndex + 1

	if newPhaseIndex >= turnStats.turnPhaseOrder.size():
		newPlayerTurn()
	else:
		turnStats.turnPhaseIndex = newPhaseIndex

	var playerStr = "ENEMY" if turnStats.turnPlayer.id == PlayerManager.PlayerID.ENEMY else "ALLY"
	var phaseStr: String

	match turnStats.turnPhase:
		TurnStats.TurnPhase.DRAW:
			phaseStr = "DRAW"
			startDrawPhase()
		TurnStats.TurnPhase.MAIN:
			phaseStr = "MAIN"
			startMainPhase()
		TurnStats.TurnPhase.END:
			phaseStr = "END"

	print("TURN: " + playerStr + " - " + phaseStr)


func _on_end_turn_button_down():
	#if turnStats.turnPhase != TurnStats.TurnPhase.DRAW:
	nextPhase()
