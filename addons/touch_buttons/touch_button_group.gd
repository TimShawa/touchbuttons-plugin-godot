@tool
class_name TouchButtonGroup extends Resource


signal pressed(button)

@export var allow_unpress := false
var _buttons := []


func _init():
	resource_local_to_scene = true
	resource_name = "TouchButtonGroup"


func get_buttons() -> Array:
	return _buttons.duplicate()


func get_pressed_button():
	for i in _buttons:
		if i.button_pressed:
			return i
	return null
