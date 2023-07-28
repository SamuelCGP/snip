extends Control
class_name CardNode

enum FlipState { DOWN = 0, UP = 1 }

signal clicked(card: CardNode)
signal summonAttempted(card: CardNode)

@onready var cardNameLabel: Label = $CardName
@onready var contextMenu: VBoxContainer = $ContextMenu
@onready var summonBtn: Button = contextMenu.get_node("Summon")
@onready var attackBtn: Button = contextMenu.get_node("Attack")
@onready var effect: Button = contextMenu.get_node("Effect")

enum CardState {
	SUMMONED, IN_HAND, IN_GRAVEYARD
}

var cardData: CardData
var cardSelected: bool = false:
	set(value):
		cardSelected = value
		if value:
			contextMenu.visible = true
			modulate = Color.RED
		else:
			contextMenu.visible = false
			modulate = Color.WHITE

var flipState: FlipState = FlipState.DOWN

var playerOwner: Player

var canSummon: bool = false:
	set(value):
		canSummon = value

		if(playerOwner.id == PlayerManager.PlayerID.ALLY):
			if(value):
				showSummonBtn()
			else:
				hideSummonBtn()

var state: CardState = CardState.IN_HAND:
	set(value):
		state = value
		match(state):
			CardState.SUMMONED, CardState.IN_GRAVEYARD:
				canSummon = false

func _ready():
	add_to_group("card")

	cardNameLabel.text = cardData.cardName

func onClick():
	clicked.emit(self)

func showSummonBtn():
	summonBtn.visible = true

func hideSummonBtn():
	summonBtn.visible = false

func _on_effect_button_down():
	pass # Replace with function body.

func _on_attack_button_down():
	pass # Replace with function body.

func _on_summon_button_down():
	if canSummon:
		summonAttempted.emit(self)
