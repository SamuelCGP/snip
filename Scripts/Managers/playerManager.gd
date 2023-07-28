extends Node
class_name PlayerManager

enum PlayerID { ALLY = 0, ENEMY = 1 }

signal willChanged(player: Player)

var players := {
	PlayerID.ALLY: Player.new(PlayerID.ALLY), PlayerID.ENEMY: Player.new(PlayerID.ENEMY)
}

func onTurnStarted(_turnStats):
	for player in players:
		player.will = min(player.will + player.willPerTurn, player.maxWill)


func onCardSummon(
	card: CardNode,
):
	if card.cardData.willCost:
		card.playerOwner.will -= card.cardData.willCost
		willChanged.emit(card.playerOwner)
