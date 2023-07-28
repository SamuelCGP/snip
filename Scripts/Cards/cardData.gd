class_name CardData

enum Category { TEST }

enum Attribute { TEST }

enum Type { TEST }

enum CardType { MONSTER, MAGE, PROPHECY, SPELL }

const IdChar = {MONSTER = "B", MAGE = "M", PROPHECY = "P", SPELL = "S"}

const CARD_DATA_DIRECTORY = "res://Data/Cards"

var id: String
var cardName: String
var category: Category
var type: Type
var attribute: Attribute
var cardType: CardType

#TODO: a logica do efeito das cartas vai ser complicada... (sei nem por onde comecar)
#var effect


func _init(
	_id: String,
	_cardName: String,
	_category: Category,
	_type: Type,
	_attribute: Attribute,
	_cardType: CardType
):
	id = _id
	cardName = _cardName
	category = _category
	type = _type
	attribute = _attribute
	cardType = _cardType


func serialize():
	return self.id


static func deserialize(cardId: String) -> CardData:
	var cardData: CardData

	var pathToCSV := CARD_DATA_DIRECTORY

	match cardId[0]:
		IdChar.MONSTER:
			pathToCSV += "/monsters.csv"
		IdChar.SPELL:
			pathToCSV += "/spells.csv"
		IdChar.PROPHECY:
			pathToCSV += "/prophecies.csv"
		IdChar.MAGE:
			pathToCSV += "/mages.csv"

	var data = CSVHelper.csvToDictById(pathToCSV, cardId)

	match cardId[0]:
		IdChar.MONSTER:
			cardData = MonsterCardData.new(
				cardId,
				data.name,
				int(data.category) as Category,
				int(data.attribute) as Attribute,
				int(data.type) as Type,
				int(data.willCost),
				data.effect,
				int(data.attack),
				int(data.hp),
				data.sigils
			)
		IdChar.SPELL:
			pathToCSV += "/spells.csv"
		IdChar.PROPHECY:
			pathToCSV += "/prophecies.csv"
		IdChar.MAGE:
			pathToCSV += "/mages.csv"

	return cardData
