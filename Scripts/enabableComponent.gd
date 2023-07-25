extends Control


func disable():
	get_parent().isEnabled = false


func enable():
	get_parent().isEnabled = true
