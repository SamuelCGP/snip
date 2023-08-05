class_name CardData

enum Archetype { TEST, NATURE, SPIRIT }

enum Type { ELF, ELEMENTAL_MAGE, TEST }

enum Function { CREATURE, MAGE, PROPHECY, SPELL }

const IdChar = {CREATURE = "C", MAGE = "M", PROPHECY = "P", SPELL = "S"}

const CARD_DATA_DIRECTORY = "res://Data/Cards"

var id: String
var cardName: String
var types: Array[Type]
var archetype: Archetype
var function: Function
var effectText: String
var effects: Array[CardEffectData] = []
var location: CardFilter.CardLocation

func _init(
	_id: String,
	_cardName: String,
	_types: Array[Type],
	_archetype: Archetype,
	_function: Function,
):
	id = _id
	cardName = _cardName
	types = _types
	archetype = _archetype
	function = _function

func serialize():
	return self.id


static func deserialize(cardId: String) -> CardData:
	var data: Dictionary

	match cardId[0]:
		IdChar.CREATURE:
			data = Global.creatures[cardId]
		IdChar.MAGE:
			data = Global.mages[cardId]

	var cardTypes: Array[Type] = []
	for type in data.types:
		cardTypes.append(Type.get(type))

	var cardArchetype: Archetype = Archetype.get(data.archetype)
	
	var cardData: CardData
	
	match cardId[0]:
		IdChar.CREATURE:
			var sigils: Array[CreatureCardData.Sigil] = []
			
			if data.has("sigils"):
				for sigil in data.sigils:
					sigils.append(CreatureCardData.Sigil.get(sigil))

			cardData = CreatureCardData.new(
				cardId,
				data.name,
				cardArchetype,
				cardTypes,
				int(data.willCost),
				int(data.attack),
				int(data.hp),
				sigils
			)
		IdChar.MAGE:
			cardData = MageCardData.new(
				cardId,
				data.name,
				cardArchetype,
				cardTypes,
				int(data.hp),
				int(data.skillPoints)

			)

	if data.has("effects"):
		cardData.effectText = data.effectText
		for effect in data.effects:
			cardData.effects.append(CardEffectData.deserialize(effect))	

	return cardData
