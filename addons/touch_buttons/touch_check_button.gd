@tool
@icon("res://addons/touch_buttons/icons/icon_touch_check_button.png")
class_name TouchCheckButton extends TouchButton


## A touchscreen button that represents a binary choice.
## 
## [TouchCheckButton] is a toggle button displayed as a check field, multitouch-support included. It's similar to [TouchCheckBox] in functionality, but it has a different appearance.
## To follow established UX patterns, it's recommended to use [TouchCheckButton] when toggling it has an [b]immediate[/b] effect on something.
## For example, it can be used when pressing it shows or hides advanced settings, without asking the user to confirm this action.[br]
## [br]
## See also [TouchBaseButton] which contains common properties and methods associated with this node.[br]
## [br]
## [i]Touchscreen equivalent of buiilt-in [CheckButton].[/i]


func _init(text := ""):
	super(text)
	press_mode = PressMode.MODE_TOGGLE
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	_theme_type = "TouchCheckButton"


func _ready() -> void:
	super()
	var check := TextureRect.new()
	check.name = "Check"
	_n_hbox().add_child(check)
	check.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	queue_redraw()


func _n_check() -> TextureRect:
	if has_node("__button_panel/HBoxContainer/Check"):
		return $__button_panel/HBoxContainer/Check
	return null


func _draw() -> void:
	super()
	
	var item := "checked" if button_pressed else "unchecked"
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
