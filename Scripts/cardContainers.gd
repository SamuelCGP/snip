extends Control
class_name CardContainers

signal effectRequirementsMet(effect: CardEffectData)

@onready var board: Board = $Board
@onready var hands: Array[Hand] = [$AllyHand, $EnemyHand]

signal cardSummoned(card: CardNode)

func connectSignals():
	for id in PlayerManager.PlayerID.values():
		board.boardSides[id].summonTargetSet.connect(onSummonTargetSet)
		hands[id].summonAttempted.connect(onSummonAttempt)

		board.decks[id].drawnCards.connect(hands[id].onCardsDraw)

func _ready():
	connectSignals()

func onEffectAttempted(effect: CardEffectData):
	if effectRequirementsCheck(effect):
		effectRequirementsMet.emit(effect)

func effectRequirementsCheck(effect: CardEffectData) -> bool:
	if effect.hasCost():
		if effect.cost.will > effect.source.playerOwner.will:
			return false
		
		if effect.cost.energy > PlayerManager.getEnergy(effect.source.playerOwner, effect.source.cardData.archetype):
			return false

	if(effect.requirements == null):
		return true

	var requirements := effect.requirements

	if requirements.cardsExist:

		for filter in requirements.cardsExist:
			var searchResult := searchCards(effect.source.playerOwner, filter)
			if searchResult.size() < filter.amount:
				return false

	return true

func searchCards(searcherPlayer: Player, filter: CardFilter) -> Array[CardData]:
	var targetInvs: Array[CardInventoryComponent] = []
	if filter.locations.has(CardFilter.CardLocation.BOARD):
		for boardSide in board.boardSides:
			boardSide = boardSide as BoardSide
			if CardFilter.isTargetOwner(searcherPlayer, boardSide.playerOwner, filter.targetOwner):
				targetInvs.append(boardSide.summonedCardsInv)
	if filter.locations.has(CardFilter.CardLocation.DECK):
		for boardSide in board.boardSides:
			var deck: DeckContainer = (boardSide as BoardSide).deck
			if CardFilter.isTargetOwner(searcherPlayer, deck.playerOwner, filter.targetOwner):
				targetInvs.append(deck.inventory)
	if filter.locations.has(CardFilter.CardLocation.HAND):
		for hand in hands:
			hand = hand as Hand
			if CardFilter.isTargetOwner(searcherPlayer, hand.playerOwner, filter.targetOwner):
				targetInvs.append(hand.inventory)

	var searchResult : Array[CardData]= []

	for inv in targetInvs:
		inv = inv as CardInventoryComponent
		var result := inv.searchCards(filter)
		searchResult.append_array(result)

	return searchResult

func onSummonTargetSet(card: CardNode, target: CardSlot, boardSide: BoardSide):
	hands[card.playerOwner.id].removeCard(card)
	card.state = CardNode.CardState.SUMMONED
	boardSide.placeCardAtSlot(card, target)
	cardSummoned.emit(card)

func onSummonAttempt(card: CardNode):
	var boardSide: BoardSide = board.boardSides[card.playerOwner.id]
	boardSide.onSummonAttempt(card)


func setOwners(players: Dictionary):
	board.setOwners(players)
	
	for id in PlayerManager.PlayerID.values():
		hands[id].setOwner(players[id])

		board.boardSides[id].summonMage()
		board.decks[id].firstDraw()


func setDeckCanDraw(value: bool, turnPlayerId: PlayerManager.PlayerID):
	for deck in board.decks:
		deck = deck as DeckContainer
		if deck.playerOwner.id == turnPlayerId:
			deck.canDraw = value


func onMainPhaseStarted():
	board.canBattle = true
	board.onMainPhaseStarted()

func onMainPhaseEnded():
	board.canBattle = false
