extends CardData
class_name MageCardData

var skillPoints: int
var hp: int

func _init(
	_id: String,
	_cardName: String,
	_archetype: Archetype,
	_types: Array[Type],
	_hp: int,
	_skillPoints: int
):
	super(_id, _cardName, _types, _archetype, CardData.Function.MAGE)
	hp = _hp
	skillPoints = _skillPoints