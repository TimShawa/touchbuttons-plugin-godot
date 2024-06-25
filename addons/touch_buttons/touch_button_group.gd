@tool
@icon("res://addons/touch_buttons/icons/icon_touch_button_group.png")
class_name TouchButtonGroup extends Resource


## A group of touchscreen buttons that doesn't allow more than one button to be pressed at a time.
## 
## A group of [TouchBaseButton]-derived buttons. The buttons in a [TouchButtonGroup] are treated like radio buttons: No more than one button can be pressed at a time.
## Some types of buttons (such as [TouchCheckBox]) may have a special appearance in this state.[br]
## [br]
## Every member of a [TouchButtonGroup] should have [member press_mode] set to [constant TouchBaseButton.PressMode.MODE_TOGGLE].[br]
## [br]
## [i]Touchscreen equivalent of built-in [ButtonGroup].[/i]


## Emitted when one of the buttons of the group is pressed.
signal pressed(button)


## If true, it is possible to unpress all buttons in this [TouchButtonGroup].
@export var allow_unpress := false:
	set = set_allow_unpress, get = is_allow_unpress
	
var _buttons := []


func set_allow_unpress(value): allow_unpress = value
func is_allow_unpress(): return allow_unpress


func _init():
	resource_local_to_scene = true
	resource_name = "TouchButtonGroup"


## Returns an [Array] of [TouchButtons] who have this as their [TouchButtonGroup] (see [member BaseButton.button_group]).
func get_buttons() -> Array:
	return _buttons.duplicate()


## Returns the current pressed button.
func get_pressed_button():
	for i in _buttons:
		if i.button_pressed:
			return i
	return null
