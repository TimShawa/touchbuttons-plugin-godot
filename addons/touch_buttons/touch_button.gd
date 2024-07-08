@tool
@icon("res://addons/touch_buttons/icons/icon_touch_button.svg")
class_name TouchButton extends TouchBaseButton


## A themed button that can contain text and an icon.
## 
## [TouchButton] is the standard themed touchscreen button. It can contain text and an icon, and it will display them according to the current [Theme].[br]
## 
## [b]Example of creating a button and assigning an action when pressed by code:[/b]
## [codeblock]
## func _ready():
##     var button = Button.new()
##     button.text = "Click me"
##     button.pressed.connect(self._button_pressed)
##     add_child(button)
## 
## func _button_pressed():
##     print("Hello world!")
## [/codeblock]
## See also [TouchBaseButton] which contains common properties and methods associated with this node.[br]
## [br]
## [TouchButton]s ACTUALLY interpret touch input and support multitouch, unlike built-in [Button]s.
## [br]
## To change button appearance attach [Theme] resourse to the node and modify its parameters. Also custom [member theme_type_variation] will be used, if specified.
## Theme properties and default values can be found at [code]res://addons/touch_buttons/buttons_theme.tres[/code].[br]
## [br]
## [i]Touchscreen equivalent of buiilt-in [Button].[/i]

## The button's text that will be displayed inside the button's area.
var text := "":
	set = set_text, get = get_text

## Button's icon, if text is present the icon will be placed before the text.[br]
## To edit margin and spacing of the icon, use [theme_item h_separation] theme property and [code]content_margin_*[/code] properties of the used [StyleBox]es.
var icon: Texture:
	set = set_icon, get = get_icon

## Flat buttons don't display decoration.
var flat := false:
	set = set_flat, get = is_flat

# Text Behavior

## Text alignment policy for the button's text, use one of the [enum HorizontalAlignment] constants.
var alignment: int = HORIZONTAL_ALIGNMENT_CENTER:
	set = set_alignment, get = get_alignment

## Sets the clipping behavior when the text exceeds the node's bounding rectangle. See [enum TextServer.OverrunBehavior] for a description of all modes.
var text_overrun_behavior: int = TextServer.OVERRUN_NO_TRIMMING:
	set = set_text_overrun_behavior, get = get_text_overrun_behavior

## If set to something other than [constant TextServer.AUTOWRAP_OFF], the text gets wrapped inside the node's bounding rectangle.
var autowrap_mode: int = TextServer.AUTOWRAP_OFF:
	set = set_autowrap_mode, get = get_autowrap_mode

## When this property is enabled, text that is too large to fit the button is clipped, when disabled the [TouchButton] will always be wide enough to hold the text.
var clip_text := false:
	set = set_clip_text, get = get_clip_text

# Icon Behavior
## Specifies if the icon should be aligned horizontally to the left, right, or center of a button.
## Uses the same [enum HorizontalAlignment] constants as the text alignment.
## If centered horizontally and vertically, text will draw on top of the icon.
var icon_alignment := HORIZONTAL_ALIGNMENT_LEFT:
	set = set_icon_alignment, get = get_icon_alignment

## Specifies if the icon should be aligned vertically to the top, bottom, or center of a button.
## Uses the same [enum VerticalAlignment] constants as the text alignment.
## If centered horizontally and vertically, text will draw on top of the icon.
var vertical_icon_alignment := VERTICAL_ALIGNMENT_CENTER:
	set = set_vertical_icon_alignment, get = get_vertical_icon_alignment

## When enabled, the button's icon will expand/shrink to fit the button's size while keeping its aspect.
var expand_icon := false:
	set = set_expand_icon, get = is_expand_icon # See also [theme_item icon_max_width]. TODO

## Base text writing direction.
var text_direction := TextServer.DIRECTION_AUTO:
	set = set_text_direction, get = get_text_diraction

## Language code used for line-breaking and text shaping algorithms, if left empty current locale is used instead.
var language := "":
	set = set_language, get = get_language


func _get_property_list():
	return [
		{ name = "text", type = TYPE_STRING, hint = PROPERTY_HINT_MULTILINE_TEXT },
		{ name = "icon", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "Texture" },
		{ name = "flat", type = TYPE_BOOL },
		
		{ name = "Text Behavior", type = TYPE_NIL, usage = PROPERTY_USAGE_GROUP },
		{ name = "alignment", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Left,Center,Right" },
		{ name = "text_overrun_behavior", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Trim Nothing,Trim Characters,Trim Words,Elipsis,Word Elipsis" },
		{ name = "autowrap_mode", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Off,Arbitrary,Word,Word (Smart)" },
		{ name = "clip_text", type = TYPE_BOOL },
		
		{ name = "Icon Behavior", type = TYPE_NIL, usage = PROPERTY_USAGE_GROUP },
		{ name = "icon_alignment", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Left,Center,Right" },
		{ name = "vertical_icon_alignment", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Top,Center,Bottom" },
		{ name = "expand_icon", type = TYPE_BOOL },
		
		{ name = "BiDi", type = TYPE_NIL, usage = PROPERTY_USAGE_GROUP },
		{ name = "text_direction", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Auto,Left-to-Right,Right-to-Left,Inherited" },
		{ name = "language", type = TYPE_STRING, hint = PROPERTY_HINT_LOCALE_ID }
	]


var _theme_type := "TouchButton"
var _buttons_theme = load("res://addons/touch_buttons/buttons_theme.tres")


#region SETGET

func set_text(value): text = value; queue_redraw()
func set_icon(value): icon = value; queue_redraw()
func set_flat(value): flat = value; queue_redraw()
func set_alignment(value): alignment = value; queue_redraw()
func set_text_overrun_behavior(value): text_overrun_behavior = value; queue_redraw()
func set_autowrap_mode(value): autowrap_mode = value; queue_redraw()
func set_clip_text(value): clip_text = value; queue_redraw()
func set_icon_alignment(value): icon_alignment = value; queue_redraw()
func set_vertical_icon_alignment(value): vertical_icon_alignment = value; queue_redraw()

func set_expand_icon(value):
	expand_icon = value
	size = _vec2_max(get_combined_minimum_size(), size)
	queue_redraw()

func set_text_direction(value): text_direction = value; queue_redraw()
func set_language(value): language = value; queue_redraw()


func get_text(): return text
func get_icon(): return icon
func is_flat(): return flat
func get_alignment(): return alignment
func get_text_overrun_behavior(): return text_overrun_behavior
func get_autowrap_mode(): return autowrap_mode
func get_clip_text(): return clip_text
func get_icon_alignment(): return icon_alignment
func get_vertical_icon_alignment(): return vertical_icon_alignment
func is_expand_icon(): return expand_icon
func get_text_diraction(): return text_direction
func get_language(): return language

#endregion


func _ready() -> void:
	if !is_instance_valid(_n_panel()):
		var panel = PanelContainer.new()
		add_child(panel, 0)
		panel.name = "__button_panel"
		_n_panel().call_deferred("set_anchors_preset", Control.PRESET_FULL_RECT)
		
		_n_panel().add_child(HBoxContainer.new(), true)
		_n_hbox().set_anchors_preset(Control.PRESET_FULL_RECT)
		
		_n_hbox().add_child(Control.new(), true)
		_n_control().size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_n_control().size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		_n_control().add_child(TextureRect.new(), true)
		_n_icon().mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		_n_control().add_child(Label.new(), true)
		_n_text().vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		_n_panel().add_child(Node.new(), true)
		_n_panel().get_node(^"Node").add_child(Panel.new(), true)


func _draw() -> void:
	if !is_node_ready():
		return
	
	_update_controls_size()
	
	_n_panel().self_modulate = Color.TRANSPARENT if flat else Color.WHITE
	
	_n_hbox().add_theme_constant_override("separation", get_theme_item("constant", "h_separation", _theme_type))
	
	_n_text().add_theme_font_override("font", get_theme_item("font", "font", _theme_type))
	_n_text().add_theme_color_override("font_outline_color", get_theme_item("color", "font_outline_color", _theme_type))
	_n_text().add_theme_font_size_override("font_size", get_theme_item("font_size", "font_size", _theme_type))
	_n_text().text = self.text
	_n_text().horizontal_alignment = self.alignment
	_n_text().text_overrun_behavior = self.text_overrun_behavior
	_n_text().autowrap_mode = self.autowrap_mode
	_n_text().clip_text = self.clip_text
	_n_text().text_direction = self.text_direction as TextDirection
	_n_text().language = self.language
	
	if is_instance_valid(icon):
		_n_icon().show()
		_n_icon().texture = self.icon
	elif has_theme_item("icon", "icon", _theme_type):
		_n_icon().show()
		_n_icon().texture = get_theme_item("icon", "icon", _theme_type)
	else:
		_n_icon().hide()
	
	match vertical_icon_alignment:
		VERTICAL_ALIGNMENT_TOP:
			_n_icon().size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		VERTICAL_ALIGNMENT_CENTER:
			_n_icon().size_flags_vertical = Control.SIZE_SHRINK_CENTER
		VERTICAL_ALIGNMENT_BOTTOM:
			_n_icon().size_flags_vertical = Control.SIZE_SHRINK_END
	
	if expand_icon:
		_n_icon().expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_n_icon().stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	else:
		_n_icon().expand_mode = TextureRect.EXPAND_KEEP_SIZE
		_n_icon().stretch_mode = TextureRect.STRETCH_KEEP
	
	if has_focus():
		var style: StyleBox = get_theme_item("stylebox", "focus", _theme_type)
		if is_instance_valid(style):
			style.draw(get_canvas_item(), Rect2(Vector2.ZERO, size))
	
	match get_draw_mode():
		DrawMode.DRAW_NORMAL:
			_n_panel().add_theme_stylebox_override("panel", get_theme_item("stylebox", "normal", _theme_type))
			if has_theme_item("color", "icon_normal_color", _theme_type):
				_n_icon().self_modulate = get_theme_item("color", "icon_normal_color", _theme_type)
			_n_text().add_theme_color_override("font_color", get_theme_item("color", "font_color", _theme_type))
		
		DrawMode.DRAW_PRESSED:
			_n_panel().add_theme_stylebox_override("panel", get_theme_item("stylebox", "pressed", _theme_type))
			if has_theme_item("color", "icon_pressed_color", _theme_type):
				_n_icon().self_modulate = get_theme_item("color", "icon_pressed_color")
			_n_text().add_theme_color_override("font_color", get_theme_item("color", "font_pressed_color", _theme_type))
		
		DrawMode.DRAW_HOVER:
			_n_panel().add_theme_stylebox_override("panel", get_theme_item("stylebox", "hover", _theme_type))
			if has_theme_item("color", "icon_pressed_color", _theme_type):
				_n_icon().self_modulate = get_theme_item("color", "icon_hover_color", _theme_type)
			_n_text().add_theme_color_override("font_color", get_theme_item("color", "font_hover_color", _theme_type))
		
		DrawMode.DRAW_DISABLED:
			_n_panel().add_theme_stylebox_override("panel", get_theme_item("stylebox", "disabled", _theme_type))
			if has_theme_item("color", "icon_disabled_color", _theme_type):
				_n_icon().self_modulate = get_theme_item("color", "icon_disabled_color")
			_n_text().add_theme_color_override("font_color", get_theme_item("color", "font_disabled_color", _theme_type))
		
		DrawMode.DRAW_HOVER_PRESSED:
			if has_theme_item("stylebox", "hover_pressed", _theme_type):
				_n_panel().add_theme_stylebox_override("panel", get_theme_item("stylebox", "hover_pressed", _theme_type))
			else:
				_n_panel().add_theme_stylebox_override("panel", get_theme_item("stylebox", "pressed", _theme_type))
			if has_theme_item("color", "icon_hover_pressed_color", _theme_type):
				_n_icon().self_modulate = get_theme_item("color", "icon_hover_pressed_color", _theme_type)
			_n_text().add_theme_color_override("font_color", get_theme_item("color", "font_hover_pressed_color", _theme_type))


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_THEME_CHANGED:
			queue_redraw()


func _n_panel() -> PanelContainer:
	return get_node_or_null(^"__button_panel")
func _n_hbox() -> HBoxContainer:
	return get_node_or_null(^"__button_panel/HBoxContainer")
func _n_control() -> Control:
	return get_node_or_null(^"__button_panel/HBoxContainer/Control")
func _n_icon() -> TextureRect:
	return get_node_or_null(^"__button_panel/HBoxContainer/Control/TextureRect")
func _n_text() -> Label:
	return get_node_or_null(^"__button_panel/HBoxContainer/Control/Label")
func _n_focus() -> Panel: # ForFocus
	return get_node_or_null(^"__button_panel/Node/Panel")


func _update_controls_size():
	_n_panel().size = size
	update_minimum_size()
	
	var sep: int = get_theme_item("constant", "h_separation", _theme_type)
	var con_size: Vector2 = _n_control().size
	
	if !_n_icon().visible or _n_icon().texture == null:
		_n_icon().size = Vector2.ZERO
		_n_icon().position = Vector2.ZERO
		_n_text().position = Vector2.ZERO
		_n_text().size = con_size
		return
	
	_n_icon().size = _n_icon().texture.get_size()
	var text_min_size := _n_text().get_combined_minimum_size()
	
	match icon_alignment:
		HORIZONTAL_ALIGNMENT_LEFT:
			match vertical_icon_alignment:
				VERTICAL_ALIGNMENT_TOP:
					if expand_icon:
						_n_icon().size = min((con_size.x - text_min_size.x), (con_size.y - text_min_size.y)) * Vector2.ONE
					_n_icon().position = Vector2.ZERO
					_n_text().position = _n_icon().size
					_n_text().size = con_size - _n_text().position
				VERTICAL_ALIGNMENT_CENTER:
					if expand_icon:
						_n_icon().size = min(con_size.x - text_min_size.x, con_size.y) * Vector2.ONE
					_n_icon().position = Vector2(0, (con_size.y - _n_icon().size.y) / 2)
					_n_text().position = Vector2(_n_icon().size.x, 0)
					_n_text().size = con_size - _n_text().position
				VERTICAL_ALIGNMENT_BOTTOM:
					if expand_icon:
						_n_icon().size = min(con_size.x - text_min_size.x, con_size.y - text_min_size.y) * Vector2.ONE
					_n_icon().position = Vector2(0, con_size.y - _n_icon().size.y)
					_n_text().position = Vector2(_n_icon().size.x, 0)
					_n_text().size = Vector2(con_size.x - _n_text().position.x, con_size.y - _n_icon().size.x)
		
		HORIZONTAL_ALIGNMENT_CENTER:
			match vertical_icon_alignment:
				VERTICAL_ALIGNMENT_TOP:
					if expand_icon:
						_n_icon().size = min(con_size.x, con_size.y - text_min_size.y) * Vector2.ONE
					_n_icon().position = Vector2((con_size.x - _n_icon().size.x) / 2, 0)
					_n_text().position = Vector2(0, _n_icon().size.y)
					_n_text().size = con_size - _n_text().position
				VERTICAL_ALIGNMENT_CENTER:
					if expand_icon:
						_n_icon().size = min(con_size.x, con_size.y) * Vector2.ONE
					_n_icon().position = (con_size - _n_icon().size) / 2
					_n_text().position = Vector2.ZERO
					_n_text().size = con_size
				VERTICAL_ALIGNMENT_BOTTOM:
					if expand_icon:
						_n_icon().size = min(con_size.x, con_size.y - text_min_size.y) * Vector2.ONE
					_n_icon().position = Vector2((con_size.x - _n_icon().size.x) / 2, con_size.y - _n_icon().size.y)
					_n_text().position = Vector2.ZERO
					_n_text().size = Vector2(con_size.x, con_size.y - _n_icon().size.y)
		
		HORIZONTAL_ALIGNMENT_RIGHT:
			match vertical_icon_alignment:
				VERTICAL_ALIGNMENT_TOP:
					if expand_icon:
						_n_icon().size = min(con_size.x - text_min_size.x, con_size.y - text_min_size.y) * Vector2.ONE
					_n_icon().position = Vector2(con_size.x - _n_icon().size.x, 0)
					_n_text().position = Vector2(0, _n_icon().size.y)
					_n_text().size = Vector2(_n_icon().position.x, con_size.y - _n_text().position.y)
				VERTICAL_ALIGNMENT_CENTER:
					if expand_icon:
						_n_icon().size = min(con_size.x - text_min_size.x, con_size.y) * Vector2.ONE
					_n_icon().position = Vector2(con_size.x - _n_icon().size.x, (con_size.y - _n_icon().size.y) / 2)
					_n_text().position = Vector2.ZERO
					_n_text().size = Vector2(_n_icon().position.x, con_size.y)
				VERTICAL_ALIGNMENT_BOTTOM:
					if expand_icon:
						_n_icon().size = min(con_size.x - text_min_size.x, con_size.y - text_min_size.y) * Vector2.ONE
					_n_icon().position = con_size - _n_icon().size
					_n_text().position = Vector2.ZERO
					_n_text().size = _n_icon().position


func _get_minimum_size() -> Vector2:
	if !is_node_ready():
		await ready
	
	var separation = get_theme_item("constant", "h_separation", _theme_type)
	var stylebox: StyleBox = _n_panel().get_theme_stylebox("panel","PanelContainer")
	var borders := Vector2(
		stylebox.content_margin_left + stylebox.content_margin_right,
		stylebox.content_margin_top + stylebox.content_margin_bottom)
	
	var min_size := borders
	var text_size := _n_text().get_combined_minimum_size()
	
	if !_n_icon().visible or _n_icon().texture == null or expand_icon:
		return min_size + text_size
	
	if !text.is_empty():
		if icon_alignment == HORIZONTAL_ALIGNMENT_CENTER:
			min_size.x += separation
		if vertical_icon_alignment == VERTICAL_ALIGNMENT_CENTER:
			min_size.y += separation
	
	var icon_size = _n_icon().texture.get_size()
	
	if 1 not in [ icon_alignment, vertical_icon_alignment ]:
		min_size += text_size + icon_size
	elif icon_alignment == 1 and vertical_icon_alignment != 1:
		min_size += Vector2(
			max(text_size.x, icon_size.x),
			text_size.y + icon_size.y)
	elif icon_alignment != 1 and vertical_icon_alignment == 1:
		min_size += Vector2(
			text_size.x + icon_size.x,
			max(text_size.y, icon_size.y))
	else:
		min_size += _vec2_max(text_size, icon_size)
	
	return min_size


func get_theme_item(item: StringName, name: StringName, theme_type: StringName = "") -> Variant:
	if !theme_type_variation.is_empty():
		theme_type = theme_type_variation
	if theme and theme.call("has_%s" % item, name, theme_type):
		return theme.call("get_%s" % item, name, theme_type)
	elif _buttons_theme.call("has_%s" % item, name, theme_type):
		return _buttons_theme.call("get_%s" % item, name, theme_type)
	match item:
		"color": return Color.TRANSPARENT
		"constant": return 0
		"font": return ThemeDB.get_default_theme().default_font
		"font_size": return ThemeDB.get_default_theme().default_font_size
		"icon": return Texture2D.new()
		"stylebox": return StyleBoxEmpty.new()
	return null


func has_theme_item(item: StringName, name: StringName, theme_type: StringName = "") -> Variant:
	if !theme_type_variation.is_empty():
		theme_type = theme_type_variation
	if theme and theme.call("has_%s" % item, name, theme_type):
		return true
	elif _buttons_theme.call("has_%s" % item, name, theme_type):
		return true
	return false


func _init(text := ""):
	set_text(text)


func _vec2_max(a: Vector2, b: Vector2):
	return Vector2(
		maxf(a.x, b.x),
		maxf(a.y, b.y)
	)
