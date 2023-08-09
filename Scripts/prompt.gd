extends Control
class_name Prompt

signal optionSelected

var selectedOption: int = -1

@export var buttonScene: PackedScene

@onready var label = %Label
@onready var btnContainer = %ButtonContainer

func start(text: String, options: Array[String] = ["Yes", "No"]):
	label.text = text

	for i in options.size():
		var btn: Button = buttonScene.instantiate()
		btn.text = options[i]
		btnContainer.add_child(btn)
		btn.button_down.connect(onBtnClick.bind(i))

func stop():
	queue_free()

func onBtnClick(btnIndex: int):
	selectedOption = btnIndex
	optionSelected.emit(selectedOption)
