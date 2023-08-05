extends Node

var creatures: Dictionary = JsonHelper.jsonToDict("res://Data/Cards/creatures.json")
var mages: Dictionary = JsonHelper.jsonToDict("res://Data/Cards/mages.json")
#var prophecies: Dictionary = JsonHelper.jsonToDict("res://Data/Cards/prophecies.json")
#var spells: Dictionary = JsonHelper.jsonToDict("res://Data/Cards/spells.json")

var selectedCard: CardNode:
	set(value):
		if selectedCard:
			selectedCard.cardSelected = false

		selectedCard = value

		if selectedCard:
			selectedCard.cardSelected = true
