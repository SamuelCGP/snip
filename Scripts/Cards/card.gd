extends TextureRect
class_name CardNode

enum FlipState { DOWN = 0, UP = 1 }

signal clicked(card: CardNode)
signal summonAttempted(card: CardNode)
signal attackAttempted(card: CardNode)
signal destroyed(card: CardNode)
signal markerAdded(card: CardNode)

@onready var cardNameLabel: Label = $CardName
@onready var contextMenu: VBoxContainer = $ContextMenu
@onready var summonBtn: Button = contextMenu.get_node("Summon")
@onready var attackBtn: Button = contextMenu.get_node("Attack")
@onready var effectBtn: Button = contextMenu.get_node("Effect")

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

var canAttack: bool = false:
	set(value):
		canAttack = value

		if(playerOwner.id == PlayerManager.PlayerID.ALLY):
			if(value):
				showAttackBtn()
			else:
				hideAttackBtn()

var canBeTargeted: bool = false

var flipState: FlipState = FlipState.DOWN

var playerOwner: Player
var selectable: bool = true

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
			CardState.IN_GRAVEYARD:
				cardData.location = CardFilter.CardLocation.GRAVEYARD
				selectable = false
				canSummon = false
			CardState.SUMMONED:
				cardData.location = CardFilter.CardLocation.BOARD
				selectable = true

				if cardData.function != CardData.Function.MAGE:
					canSummon = false
			CardState.IN_HAND:
				cardData.location = CardFilter.CardLocation.HAND
				selectable = true

func _ready():
	add_to_group("card")

	cardNameLabel.text = cardData.cardName

func addMarker(attack: int, hp: int):
	cardData.attack += attack
	cardData.hp += hp

	markerAdded.emit(self)

func verifyCanSummon():
	if cardData.function == CardData.Function.MAGE:
		return

	if playerOwner.isTurnPlayer:
		if state == CardNode.CardState.IN_HAND:
			if !cardData.willCost:
				canSummon = true
			elif cardData.willCost <= playerOwner.will:
				canSummon = true
			else:
				canSummon = false
		else:
			canSummon = false

func onClick():
	if selectable && playerOwner.id == PlayerManager.PlayerID.ALLY:
		if Global.selectedCard != self:
			Global.selectedCard = self
		else: Global.selectedCard = null

	clicked.emit(self)

func showSummonBtn():
	summonBtn.visible = true

func hideSummonBtn():
	summonBtn.visible = false

func showAttackBtn():
	attackBtn.visible = true
	
func hideAttackBtn():
	attackBtn.visible = false

func showEffectBtn():
	effectBtn.visible = true
		
func hideEffectBtn():
	effectBtn.visible = false

func _on_effect_button_down():
	pass # Replace with function body.

func _on_attack_button_down():
	attackAttempted.emit(self)

func _on_summon_button_down():
	summonAttempted.emit(self)
