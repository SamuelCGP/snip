extends Control
class_name CardNode

enum FlipState { DOWN = 0, UP = 1 }

signal clicked(card: CardNode)
signal summoned

@onready var cardNameLabel: Label = $CardName

var cardData: CardData
var cardSelected: bool = false:
	set(isSelected):
		cardSelected = isSelected
		if isSelected:
			modulate = Color.RED
		else:
			modulate = Color.WHITE

var flipState: FlipState = FlipState.DOWN


func _ready():
	cardNameLabel.text = cardData.cardName


func _process(delta):
	pass


func onClick():
	clicked.emit(self)
