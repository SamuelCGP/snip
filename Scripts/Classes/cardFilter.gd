class_name CardFilter

enum TargetOwner {
	SELF, OPPONENT, ANY
}

enum CardLocation {
	DECK, BOARD, HAND, GRAVEYARD
}

var maxWillCost: int = -1
var type: Array[CardData.Type]
var archetype: Array[CardData.Archetype]
var function: CardData.Function
var state: CardNode.CardState
var targetOwner: TargetOwner
var attack: int = -1
var maxAttack: int = -1
var hp: int = -1
var maxHp: int = -1
var ids: Array[String]
var amount: int = -1
var isSelf: bool = false
var locations: Array[CardLocation]

static func isTargetOwner(playerA: Player, playerB: Player, filterTargetOwner: CardFilter.TargetOwner) -> bool:
	if filterTargetOwner == CardFilter.TargetOwner.ANY:
		return true

	var result := false

	match(filterTargetOwner):
		CardFilter.TargetOwner.SELF:
			result = playerA == playerB
		CardFilter.TargetOwner.OPPONENT:
			result = playerA != playerB

	return result

static func validateFilter(card: CardData, filter: CardFilter) -> bool:
	if !filter.ids.is_empty():
		if !filter.ids.has(card.id):
			return false

	if filter.maxWillCost != -1:
		if card.will > filter.maxWillCost:
			return false

	if !filter.type.is_empty():
		if !filter.type.has(card.type):
			return false

	if !filter.archetype.is_empty():
		if !filter.archetype.has(card.archetype):
			return false

	if filter.attack != -1:
		if filter.attack != card.attack:
			return false

	if filter.maxAttack != -1:
		if card.attack > filter.maxAttack:
			return false

	if filter.hp != -1:
		if filter.hp != card.hp:
			return false

	if filter.maxHp != -1:
		if card.maxHp > filter.maxHp:
			return false

	if filter.function != null:
		if card.function != filter.function:
			return false

	return true

static func deserialize(filtersData: Array) -> Array[CardFilter]:
	var result : Array[CardFilter] = []
	
	for data in filtersData:
		var filter := CardFilter.new()
		if data.has("isSelf"):
			filter.isSelf = true
		else:
			if data.has("targetOwner"):
				filter.targetOwner = CardFilter.TargetOwner.get(data.targetOwner)
			if data.has("function"):
				filter.function = CardData.Function.get(data.function)
			if data.has("amount"): 
				filter.amount = data.amount
			if data.has("locations"):
				var filterLocations: Array[CardLocation] = []

				for location in data.locations:
					filterLocations.append(CardLocation.get(location))

				filter.locations = filterLocations

		result.append(filter)

	return result
