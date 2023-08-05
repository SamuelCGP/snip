extends CenterContainer
class_name UICard

signal clicked(card: UICard)
@onready var cardNameLabel: Label = $CardName

var cardData: CardData
var selected: bool = false:
	set(value):
		selected = value
		if(value):
			modulate = Color.RED
		else:
			modulate = Color.WHITE

# Called when the node enters the scene tree for the first time.
func initialize(data: CardData):
	cardData = data
	cardNameLabel.text = data.cardName

func onClick():
	clicked.emit(self)
