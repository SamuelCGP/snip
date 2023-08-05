extends Control
class_name MatchManager

@onready var playerManager: PlayerManager = $PlayerManager
@onready var effectManager: EffectManager = $EffectManager
@onready var cardContainers: CardContainers = $CardContainers

var turnStats: TurnStats = TurnStats.new()


func connectSignals():
	for hand in cardContainers.hands:
		hand.cardAdded.connect(effectManager.onCardAddedToHand)

	playerManager.willChanged.connect(onWillChanged)
	effectManager.effectAttempted.connect(cardContainers.onEffectAttempted)
	cardContainers.effectRequirementsMet.connect(effectManager.onEffectRequirementsMet)
	effectManager.effectStarted.connect(onEffectStarted)
	cardContainers.cardSummoned.connect(onCardSummon)

func _ready():
	Global.selectedCard = null

	turnStats.turnPlayer = playerManager.players[PlayerManager.PlayerID.ALLY]

	connectSignals()

	cardContainers.setOwners(playerManager.players)

	startDrawPhase()


func onCardSummon(card: CardNode):
	playerManager.onCardSummon(card)
	effectManager.onCardSummon(card)

func onEffectStarted(effect: CardEffectData):
	var targets: Array[CardData] = []

	for filter in effect.targetFilters:
		str(CardData.Function.find_key(filter.function))
		targets.append_array(cardContainers.searchCards(effect.source.playerOwner, filter))
	effectManager.onPossibleTargetsSearch(effect, targets, effect.targetFilters[0].amount)


func onWillChanged(_player: Player):
	for card in get_tree().get_nodes_in_group("card"):
		card = card as CardNode
		if turnStats.turnPhase == TurnStats.TurnPhase.MAIN:
			card.verifyCanSummon()
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

	if turnStats.playerTurnNumber > 2:
		newTurn()


func startMainPhase():
	cardContainers.onMainPhaseStarted()
	for card in get_tree().get_nodes_in_group("card"):
		card = card as CardNode
		card.verifyCanSummon()


func endMainPhase():
	cardContainers.onMainPhaseEnded()
	for card in get_tree().get_nodes_in_group("card"):
		card = card as CardNode
		card.canSummon = false


func startDrawPhase():
	cardContainers.setDeckCanDraw(true, turnStats.turnPlayer.id)


func endDrawPhase():
	cardContainers.setDeckCanDraw(false, turnStats.turnPlayer.id)


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

	match turnStats.turnPhase:
		TurnStats.TurnPhase.DRAW:
			startDrawPhase()
		TurnStats.TurnPhase.MAIN:
			startMainPhase()
		TurnStats.TurnPhase.END:
			pass
	
	print("TURN: " + PlayerManager.PlayerID.keys()[turnStats.turnPlayer.id]+ " - " + TurnStats.TurnPhase.keys()[turnStats.turnPhase])


func _on_end_turn_button_down():
	nextPhase()
