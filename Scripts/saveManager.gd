extends Node

const PATH_TO_SAVE = "user://game.save"


func loadSave():
	var file := FileAccess.open(PATH_TO_SAVE, FileAccess.READ)
	var data: Dictionary = str_to_var(file.get_as_text())
	file.close()

	Deck.playerDeck = data.playerDeck.map(func(cardId: String):
		CardData.deserialize(cardId)
	)


func save():
	var saveData := {}

	saveData.playerDeck = Deck.playerDeck.map(func(cardData: CardData):
		return cardData.serialize()
	)

	var dataString := var_to_str(saveData)

	var file := FileAccess.open(PATH_TO_SAVE, FileAccess.WRITE)
	file.store_string(dataString)
	file.close()
