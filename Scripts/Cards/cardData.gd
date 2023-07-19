extends Object
class_name CardData

enum Category { TEST }

enum Attribute { TEST }

enum Type { TEST }

const ID_CHARS = {
	MONSTER = "B",
	MAGE = "M",
	PROPHECY = "P",
	SPELL = "S"
}
const CARD_DATA_DIRECTORY = "res://Data/Cards"

var id: String
var cardName: String
var category: Category
var type: Type
var attribute: Attribute

#TODO: a logica do efeito das cartas vai ser complicada... (sei nem por onde comecar)
#var effect

func _init(_id: String, _cardName: String, _category: Category, _type: Type, _attribute: Attribute):
	id = _id
	cardName = _cardName
	category = _category
	type = _type
	attribute = _attribute

func serialize():
	return self.id

static func deserialize(cardId: String) -> CardData:
	var cardData: CardData

	var pathToCSV := CARD_DATA_DIRECTORY

	match cardId[0]:
		ID_CHARS.MONSTER:
			pathToCSV += "/monsters.csv"
		ID_CHARS.SPELL:
			pathToCSV += "/spells.csv"
		ID_CHARS.PROPHECY:
			pathToCSV += "/prophecies.csv"
		ID_CHARS.MAGE:
			pathToCSV += "/mages.csv"
		
	var data = CSVHelper.csvToDictById(pathToCSV, cardId)

	match cardId[0]:
		ID_CHARS.MONSTER:
			cardData = MonsterCardData.new(
						cardId,
						data.name,
						int(data.category) as Category,
						int(data.attribute) as Attribute,
						int(data.type) as Type,
						int(data.willCost),
						data.effect,
						int(data.attack),
						int(data.life),
						data.sigils)
		ID_CHARS.SPELL:
			pathToCSV += "/spells.csv"
		ID_CHARS.PROPHECY:
			pathToCSV += "/prophecies.csv"
		ID_CHARS.MAGE:
			pathToCSV += "/mages.csv"


	return cardData
