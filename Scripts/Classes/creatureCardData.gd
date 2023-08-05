extends CardData
class_name CreatureCardData

enum Sigil {
	DEFENDER, HASTE
}

var willCost: int
var attack: int
var hp: int
var sigils: Array[Sigil]

func _init(
	_id: String,
	_cardName: String,
	_archetype: Archetype,
	_types: Array[Type],
	_willCost: int,
	_attack: int,
	_hp: int,
	_sigils: Array[Sigil]
):
	super(_id, _cardName, _types, _archetype, CardData.Function.CREATURE)
	willCost = _willCost
	attack = _attack
	hp = _hp
	sigils = _sigils
