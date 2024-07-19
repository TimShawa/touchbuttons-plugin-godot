@tool
@icon("res://addons/touch_buttons/icons/icon_touch_check_box.svg")
class_name ToucCheckBox extends TouchButton


## A touchscreen button that represents a binary choice.
## 
## [TouchCheckBox] allows the user to choose one of only two possible options, multitouch-support included. It's similar to [TouchCheckButton] in functionality, but it has a different appearance. To follow established UX patterns, it's recommended to use [TouchCheckBox] when toggling it has [b]no[/b] immediate effect on something. For example, it could be used when toggling it will only do something once a confirmation button is pressed.[br]
## [br]
## See also [TouchBaseButton] which contains common properties and methods associated with this node.[br]
## [br]
## When [member TouchBaseButton.button_group] specifies a [TouchButtonGroup], [TouchCheckBox] changes its appearance to that of a radio button and uses the various [code]radio_*[/code] theme properties.[br]
## [br]
## [i]Touchscreen equivalent of buiilt-in [CheckBox].[/i]

func _init(text := ""):
	super(text)
	press_mode = PressMode.MODE_TOGGLE
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	_theme_type = "TouchCheckBox"


func _ready() -> void:
	super()
	var check := TextureRect.new()
	check.name = "Check"
	_n_hbox().add_child(check)
	_n_hbox().move_child(check, 0)
	check.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	queue_redraw()


func _n_check() -> TextureRect:
	if has_node("__button_panel/HBoxContainer/Check"):
		return $__button_panel/HBoxContainer/Check
	return null


func _draw() -> void:
	super()
	
	var item := "checked" if button_pressed else "unchecked"
	if is_instance_valid(button_group):
		item = "radio_" + item
	if disabled:
		item += "_disabled"
	_n_check().texture = get_theme_item("icon", item, _theme_type)


func _get_minimum_size() -> Vector2:
	var size = await super()
	if !is_instance_valid(_n_check()):
		return size
	if _n_check().texture == null:
		return size
	
	var stylebox: StyleBox = _n_panel().get_theme_stylebox("panel","PanelContainer")
	var border := stylebox.content_margin_top + stylebox.content_margin_bottom
	
	size.x += _n_check().size.x
	size.y = max( size.y - border, _n_check().texture.get_size().y) + border
	
	if _n_icon().visible or !text.is_empty():
		size.x += get_theme_item("constant", "h_separation", _theme_type)
	
	return size
