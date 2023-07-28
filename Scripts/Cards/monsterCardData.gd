extends CardData
class_name MonsterCardData

var willCost: int
var attack: int
var hp: int
var sigils: String

func _init(
	_id: String,
	_cardName: String,
	_category: Category,
	_attribute: Attribute,
	_type: Type,
	_willCost: int,
	_effect: String,
	_attack: int,
	_hp: int,
	_sigils: String
):
	super(_id, _cardName, _category, _type, _attribute, CardData.CardType.MONSTER)
	willCost = _willCost
	attack = _attack
	hp = _hp
	sigils = _sigils
