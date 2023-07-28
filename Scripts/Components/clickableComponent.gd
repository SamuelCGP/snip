extends Control

@onready var parent: Control = get_parent()


func _ready():
	parent.connect("gui_input", _on_gui_input)


func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if parent.has_method("onClick"):
				parent.onClick()
