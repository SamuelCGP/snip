extends Control

@onready var parent: Control = get_parent()

func _ready():
	parent.connect("gui_input", _on_gui_input)

func _input(event: InputEvent):
	if !SignalHelper.nodeHasSignal(parent, "clickedOutside"): return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if !parent.get_global_rect().has_point(get_global_mouse_position()):
				parent.emit_signal("clickedOutside")

func _on_gui_input(event:InputEvent):
	if !SignalHelper.nodeHasSignal(parent, "clicked"): return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			parent.emit_signal("clicked", parent)
