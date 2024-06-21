@tool
class_name TouchCheckButton extends TouchButton


func _init():
	toggle_mode = true
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	_theme_type = "SwitchTouchButton"


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
	
	if !is_node_ready() or !is_instance_valid(_n_check()):
		return
	
	_update_controls_size()
	
	if !is_instance_valid(theme):
		set_theme(preload("res://addons/touch_buttons/buttons.theme"))
	
	_n_panel().self_modulate = Color.TRANSPARENT if flat else Color.WHITE
	
	_n_hbox().add_theme_constant_override("separation", _get_button_constant("h_separation", _theme_type))
	
	_n_text().add_theme_font_override("font", _get_button_font("font", _theme_type))
	_n_text().add_theme_color_override("font_outline_color", _get_button_color("font_outline_color", _theme_type))
	_n_text().add_theme_font_size_override("font_size", _get_button_font_size("font_size", _theme_type))
	_n_text().text = self.text
	_n_text().horizontal_alignment = self.alignment
	_n_text().text_overrun_behavior = self.text_overrun_behavior
	_n_text().autowrap_mode = self.autowrap_mode
	_n_text().clip_text = self.clip_text
	_n_text().text_direction = self.text_direction
	_n_text().language = self.language
	
	if is_instance_valid(icon):
		_n_icon().show()
		_n_icon().texture = self.icon
	elif _has_theme_icon("icon", _theme_type):
		_n_icon().show()
		_n_icon().texture = _get_button_icon("icon", _theme_type)
	else:
		_n_icon().hide()
	
	match vertical_icon_alignment:
		VERTICAL_ALIGNMENT_TOP:
			_n_icon().size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		VERTICAL_ALIGNMENT_CENTER:
			_n_icon().size_flags_vertical = Control.SIZE_SHRINK_CENTER
		VERTICAL_ALIGNMENT_BOTTOM:
			_n_icon().size_flags_vertical = Control.SIZE_SHRINK_END
	_n_icon().expand_mode = TextureRect.EXPAND_FIT_HEIGHT if expand_icon else TextureRect.EXPAND_KEEP_SIZE
	
	match get_draw_mode():
		DrawMode.DRAW_NORMAL:
			_n_panel().add_theme_stylebox_override("panel", _get_button_stylebox("normal", _theme_type))
			_n_text().add_theme_color_override("font_color", _get_button_color("font_color", _theme_type))
		DrawMode.DRAW_PRESSED:
			_n_panel().add_theme_stylebox_override("panel", _get_button_stylebox("pressed", _theme_type))
			_n_text().add_theme_color_override("font_color", _get_button_color("font_pressed_color", _theme_type))
		DrawMode.DRAW_DISABLED:
			_n_panel().add_theme_stylebox_override("panel", _get_button_stylebox("disabled", _theme_type))
			_n_text().add_theme_color_override("font_color", _get_button_color("font_disabled_color", _theme_type))
	
	var item := "checked" if button_pressed else "unchecked"
	if disabled:
		item += "_disabled"
	_n_check().texture = _get_button_icon(item, _theme_type)


func _get_minimum_size() -> Vector2:
	if !is_instance_valid(_n_check()): return Vector2.ZERO
	var size = await super()
	size.x += _n_check().size.x
	if _n_icon().visible or !text.is_empty():
		size.x += _get_button_constant("h_separation", _theme_type)
	return size
