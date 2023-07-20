extends Control
class_name CardNode

enum FlipState {
	DOWN = 0, UP = 1
}

signal clicked(cardData: CardNode)
signal clickedOutside

@onready var cardNameLabel: Label = $CardName
#@onready var sprite: Sprite2D = $Sprite2D

var cardData: CardData
var cardSelected: bool = false:
	set(isSelected):
		cardSelected = isSelected
		if isSelected:
			modulate = Color.RED
		else:
			modulate = Color.WHITE

var flipState: FlipState = FlipState.DOWN
	#set(_flipState):
		#flipState = _flipState
		#sprite.frame = _flipState

# Called when the node enters the scene tree for the first time.
func _ready():
	cardNameLabel.text = cardData.cardName

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

