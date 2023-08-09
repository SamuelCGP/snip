extends Node
class_name PlayerManager

enum PlayerID { ALLY = 0, ENEMY = 1 }

signal willChanged(player: Player)

var players := {
	PlayerID.ALLY: Player.new(PlayerID.ALLY), PlayerID.ENEMY: Player.new(PlayerID.ENEMY)
}

func _ready():
	CardEffectSignals.gainElementalEnergy.connect(onGainElementalEnergy)

func onGainElementalEnergy(player: Player, energyType: CardData.Archetype, amount: int):
	addEnergy(player, energyType, amount)

func onTurnStarted(_turnStats):
	for player in players.values():
		player.will = min(player.will + player.willPerTurn, player.maxWill)

func onEffectStarted(effect: CardEffectData):
	if effect.hasCost():
		if effect.cost.will > 0:
			addWill(effect.source.playerOwner, -effect.cost.will)
		if effect.cost.energy > 0:
			addEnergy(effect.source.playerOwner, effect.source.cardData.archetype, -effect.cost.energy)

func addEnergy(player: Player, type: CardData.Archetype, amount: int):
	player.energy[CardData.Archetype.find_key(type)] += amount

static func getEnergy(player: Player, type: CardData.Archetype) -> int:
	return player.energy[CardData.Archetype.find_key(type)]

func addWill(player: Player, amount: int):
	player.will += amount
	willChanged.emit(player)

func onCardSummon(
	card: CardNode,
):
	if card.cardData.willCost:
		addWill(card.playerOwner, card.cardData.willCost)
