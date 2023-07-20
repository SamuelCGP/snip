extends Control

@onready var playerHand: Hand = $%Hand

func _ready():
	for node in get_tree().get_nodes_in_group("cardHolder"):
		node.connect("clicked", placeCard)

func placeCard(cardHolder: CardHolder):
	var selectedCard: CardNode = playerHand.selectedCard

	if(selectedCard && !cardHolder.content):
		playerHand.removeCard(selectedCard)
		cardHolder.addCard(selectedCard)