extends CardData
class_name MonsterCardData

var willCost: int
var attack: int
var life: int
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
	_life: int,
	_sigils: String
):
	super(_id, _cardName, _category, _type, _attribute, CardData.CardType.MONSTER)
	willCost = _willCost
	attack = _attack
	life = _life
	sigils = _sigils
	pass
