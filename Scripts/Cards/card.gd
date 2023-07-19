extends Node2D
class_name CardNode

enum FlipState {
	DOWN = 0, UP = 1
}

@onready var sprite: Sprite2D = $Sprite2D

var cardData: CardData

var flipState: FlipState = FlipState.DOWN:
	set(_flipState):
		flipState = _flipState
		sprite.frame = _flipState

# Called when the node enters the scene tree for the first time.
func _ready():
	print(cardData.cardName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
