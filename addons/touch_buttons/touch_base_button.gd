@tool
class_name TouchBaseButton extends Control


## A base class for touchscreen GUI buttons.
## 
## TouchBaseButton is base class for touchscreen GUI buttons. It doesn't display anything by itself.
## Multitouch-support included. Currently doesn't listen to [Shortcut] events.[br]
## [br]
## There is no [member BaseButton.toggle_mode], but [TouchButton]s have a [member press_mode] property. Button can have "click", "toggle" or "pass-by" press mode.
## Click mode is the default button press mode, toggle is switching-state mode
## and the pass-by press mode allows the button to press on finger/mouse enter and release on the finger/mouse exit.[br]
## [br]
## [i]Touchscreen equivalent of buiilt-in [BaseButton].[/i]

## Emitted when the button starts being held down.
signal button_down
## Emitted when the button stops being held down.
signal button_up
## Emitted when the button is toggled or pressed. This is on [signal button_down] if [member action_mode] is [enum ActionMode.ACTION_MODE_BUTTON_PRESS] and on [signal button_up] otherwise.[br]
## [br]
## If you need to know the button's pressed state (and [member toggle_mode] is active), use [signal toggled] instead.
signal pressed
## Emitted when the button was just toggled between pressed and normal states (only if [member toggle_mode] is active). The new state is contained in the [param toggled_on] argument.
signal toggled(toggled_on: bool)
## Emitted when the button forwards recieved [class InputEventScreenDrag].
signal drag_input(event)


enum ActionMode {
	## Require just a press to consider the button clicked.
	ACTION_MODE_BUTTON_PRESS,
	## Require a press and a subsequent release before considering the button clicked.
	ACTION_MODE_BUTTON_RELEASE
}

enum PressMode {
	## The default button press mode. The button become pressed on screen touch (or on the mouse button press) and become released on finger up (or mouse button release).
	MODE_CLICK,
	## The toggle press mode of a button. The button switch the state between pressed or released on any finger touch (or mouse button click).
	MODE_TOGGLE,
	## The pass-bypress mode of a button. The pressed and released signals are emitted whenever a pressed finger goes in and out of the button, even if the pressure started outside the active area of the button.
	MODE_PASSBY_PRESS
}

enum DrawMode {
	## The normal state (i.e. not pressed, not hovered, not toggled and enabled) of buttons.
	DRAW_NORMAL,
	## The state of buttons are hovered.
	DRAW_HOVER,
	## The state of buttons are pressed.
	DRAW_PRESSED,
	## The state of buttons are disabled.
	DRAW_DISABLED,
	## The state of buttons are both hovered and pressed.
	DRAW_HOVER_PRESSED
}

## If true, the button is in disabled state and can't be clicked, hovered or toggled.
var disabled := false:
	set = set_disabled, get = is_disabled

## Defines how the button reacts on input events. See [enum PressMode] for more information about button press modes.
var press_mode: int = PressMode.MODE_CLICK:
	set = set_press_mode, get = get_press_mode

## If [code]true[/code], the button's state is pressed. If you want to change the pressed state without emitting signals, use [method set_pressed_no_signal].
var button_pressed := false:
	set = set_button_pressed, get = is_button_pressed

## Determines when the button is considered clicked, one of the [enum ActionMode] constants.
var action_mode: int = ActionMode.ACTION_MODE_BUTTON_RELEASE:
	set = set_action_mode, get = get_action_mode

## If [code]true[/code] and, the button will forward any recieved [InputEventScreenDrag] with [signal drag_input] signal. Works only when [member press_mode] is [constant PressMode.MODE_CLICK]
var pass_screen_drag := false:
	set = set_pass_screen_drag, get = get_pass_screen_drag

## The [TouchButtonGroup] associated with the button. Not to be confused with node groups.[br]
## [br]
## [b]Note:[/b] The button will be configured as a radio button if a [TouchButtonGroup] is assigned to it.
var button_group: TouchButtonGroup:
	set = set_button_group, get = get_button_group

## If [code]true[/code] (by default), the button will respond to mouse clicks.
## Mouse button mask is defined by [member mouse_button_mask] property.
var mouse_enabled := true:
	set = set_mouse_enabled, get = is_mouse_enabled

## Binary mask to choose which mouse buttons this button will respond to. Makes sense only if [member mouse_enabled] is [code]true[/code].[br]
## [br]
## To allow both left-click and right-click, use [code]MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT[/code].
var mouse_button_mask: int = MOUSE_BUTTON_MASK_LEFT:
	set = set_mouse_button_mask, get = get_mouse_button_mask


func _get_property_list():
	return [
		{ name = "disabled", type = TYPE_BOOL },
		{ name = "button_pressed", type = TYPE_BOOL },
		{ name = "press_mode", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Click,Toggle,Pass-by Press" },
		{ name = "action_mode", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Button Press,Button Release" },
		{
			name = "pass_screen_drag", type = TYPE_BOOL,
			usage = (PROPERTY_USAGE_DEFAULT) if !press_mode else (PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
		},
		{ name = "mouse_enabled", type = TYPE_BOOL },
		{
			name = "mouse_button_mask", type = TYPE_INT,
			hint = PROPERTY_HINT_FLAGS, hint_string = "Mouse Left:1,Mouse Right:2,Mouse Middle:4",
			usage = (PROPERTY_USAGE_DEFAULT) if mouse_enabled else (PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY)
		},
		{ name = "button_group", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "TouchButtonGroup" },
	]


var _touch_index := -1
var _was_pressed_by_mouse := false
var _mouse_mode := false


#region SETGET

func set_press_mode(value):
	if press_mode != value:
		self.button_pressed = false
		_touch_index = false
		_was_pressed_by_mouse = false
	press_mode = value
	notify_property_list_changed()


func set_disabled(value):
	disabled = value
	if disabled and !is_toggle_mode():
		button_pressed = false


func set_button_pressed(value):
	if value:
		button_pressed = true
		_emit_pressed()
		_unpress_group()
	else:
		var can_unpress = true
		if is_toggle_mode() and is_instance_valid(button_group):
			if !button_group.allow_unpress:
				can_unpress = false
				for i: TouchBaseButton in button_group.get_buttons():
					if i == self:
						continue
					if i.is_button_pressed():
						can_unpress = true
						break
		if can_unpress:
			button_pressed = false
			_touch_index = -1
			_was_pressed_by_mouse = false
			_emit_released()


func set_action_mode(value): action_mode = value


func _emit_pressed():
	emit_signal("button_down")
	
	if is_toggle_mode():
		emit_signal("toggled", true)
		if is_instance_valid(button_group):
			button_group.emit_signal("pressed", self)
	
	if action_mode == ActionMode.ACTION_MODE_BUTTON_PRESS:
		emit_signal("pressed")


func _emit_released():
	emit_signal("button_up")
	
	if is_toggle_mode():
		emit_signal("toggled", false)
	
	if action_mode == ActionMode.ACTION_MODE_BUTTON_PRESS:
		emit_signal("pressed")


func set_pass_screen_drag(value): pass_screen_drag = value


func set_button_group(value):
	if button_group == value:
		return
	if is_instance_valid(button_group):
		button_group._buttons.erase(self)
	button_group = value
	if is_instance_valid(button_group):
		if self not in button_group._buttons:
			button_group._buttons.push_back(self)
	update_configuration_warnings()


func set_mouse_enabled(value):
	mouse_enabled = value
	notify_property_list_changed()


func set_mouse_button_mask(value):
	mouse_button_mask = value


func is_disabled(): return disabled
func get_press_mode(): return press_mode
func is_button_pressed(): return button_pressed
func get_action_mode(): return action_mode
func get_pass_screen_drag(): return pass_screen_drag
func get_button_group(): return button_group
func is_mouse_enabled(): return mouse_enabled
func get_mouse_button_mask(): return mouse_button_mask

#endregion


## Returns [code]true[/code] if the button is in the toggle mode ([member press_mode] is [constant PressMode.MODE_TOGGLE]).
func is_toggle_mode() -> bool:
	return press_mode == PressMode.MODE_TOGGLE


## Returns [code]true[/code] if the button is in the pass-by press mode ([member press_mode] is [constant PressMode.MODE_PASSBY_PRESS]).
func get_passby_press() -> bool:
	return press_mode == PressMode.MODE_PASSBY_PRESS


func _init(text: String = "") -> void:
	mouse_filter = MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL
	
	if !pressed.is_connected(_pressed):
		pressed.connect(_pressed)
	if !toggled.is_connected(_toggled):
		toggled.connect(_toggled)
	if !resized.is_connected(_on_resized):
		resized.connect(_on_resized)

func _input(event: InputEvent) -> void:
	
	if is_disabled():
		return
	
	if event.device == InputEvent.DEVICE_ID_EMULATION:
		return
	
	if !Engine.is_editor_hint():
		
		if event is InputEventAction:
			if event.action == "ui_accept":
				if event.pressed:
					self.button_pressed = true
					await get_tree().process_frame
					self.button_pressed = false
		
		if event is InputEventScreenTouch or event is InputEventScreenDrag:
			if !_was_pressed_by_mouse and !is_button_pressed():
				_mouse_mode = false
		if event is InputEventMouse:
			if _was_pressed_by_mouse or !is_button_pressed():
				_mouse_mode = true
		
		match press_mode:
			
			PressMode.MODE_CLICK:
				
				if event is InputEventScreenTouch:
					if event.is_pressed() and !is_button_pressed(): # PRESS
						if _has_point(event.position):
							self.button_pressed = true
							_touch_index = event.index
					if event.is_released() and is_button_pressed(): # RELEASE
						if !_was_pressed_by_mouse:
							if event.index == _touch_index:
								self.button_pressed = false
				
				if event is InputEventMouseButton:
					if mouse_button_mask & _get_button_mask(event.button_index):
						if event.is_pressed() and !is_button_pressed(): # PRESS
							if _has_point(event.position):
								self.button_pressed = true
								_was_pressed_by_mouse = true
						if event.is_released() and is_button_pressed(): # RELEASE
							if _was_pressed_by_mouse:
								self.button_pressed = false
				
				if pass_screen_drag:
					
					if event is InputEventScreenDrag:
						if is_button_pressed():
							drag_input.emit(event.duplicate())
					
					if event is InputEventMouseMotion:
						if is_button_pressed():
							var drag = InputEventScreenDrag.new()
							
							for i in [
								"index",
								"tilt", "pressure", "pen_inverted",
								"position",
								"relative", "screen_relative",
								"velocity", "screen_velocity",
								"window_id", "device"
							]:
								if i in event:
									drag.set(i, event.get(i))
							
							drag_input.emit(drag)
			
			PressMode.MODE_TOGGLE:
				
				if event is InputEventScreenTouch:
					if _has_point(event.position):
						if event.is_pressed():
							self.button_pressed = not button_pressed
				
				if event is InputEventMouseButton:
					if mouse_button_mask & _get_button_mask(event.button_index):
						if event.is_pressed():
							if _has_point(event.position):
								self.button_pressed = not button_pressed
			
			PressMode.MODE_PASSBY_PRESS:
				
				if event is InputEventScreenTouch:
					if _has_point(event.position):
						if event.is_pressed() and !is_button_pressed(): # PRESS
							self.button_pressed = true
							_touch_index = event.index
						if event.is_released() and is_button_pressed(): # RELEASE
							if !_was_pressed_by_mouse:
								if _touch_index == event.index:
									self.button_pressed = false
				
				if event is InputEventScreenDrag:
					if !is_button_pressed() and _has_point(event.position): # ENTER
						self.button_pressed = true
						_touch_index = event.index
					if is_button_pressed() and !_has_point(event.index): # EXIT
						if !_was_pressed_by_mouse:
							if event.index == _touch_index:
								self.button_pressed = false
				
				if event is InputEventMouseButton:
					if mouse_button_mask & _get_button_mask(event.button_index):
						if event.is_pressed() and !is_button_pressed(): # PRESS
							self.button_pressed = true
							_was_pressed_by_mouse = true
						if event.is_released() and is_button_pressed(): # RELEASE
							if _was_pressed_by_mouse:
								self.button_pressed = false
				
				if event is InputEventMouseMotion:
					print(event.button_mask)
					if mouse_button_mask & _get_button_mask(event.button_index):
						if _has_point(event.position) and !is_button_pressed(): # ENTER
							self.button_pressed = true
							_was_pressed_by_mouse = true
						if !_has_point(event.position) and is_button_pressed(): # EXIT
							if _was_pressed_by_mouse:
								self.button_pressed = false


## If button was pressed by touch, returns the touch index, -1 otherwise.
func get_touch_index():
	return _touch_index


## Returns the visual state used to draw the button. This is useful mainly when implementing your own draw code by either overriding [method _draw] or connecting to "draw" signal.
## The visual state of the button is defined by the [enum DrawMode] enum.
func get_draw_mode() -> DrawMode:
	if disabled:
		return DrawMode.DRAW_DISABLED
	if button_pressed:
		if is_hovered():
			return DrawMode.DRAW_HOVER_PRESSED
		return DrawMode.DRAW_PRESSED
	if is_hovered():
		return DrawMode.DRAW_HOVER
	return DrawMode.DRAW_NORMAL


## Returns [code]true[/code] if the button is hovered by [b]mouse cursor[/b].
## If [member mouse_enabled] is [code]false[/code], this method will also return [code]false[/code]
func is_hovered() -> bool:
	return !Engine.is_editor_hint() and _mouse_mode and _has_point(get_global_mouse_position())


## Changes the [member button_pressed] state of the button, without emitting [signal toggled].
## Use when you just want to change the state of the button without sending the pressed event (e.g. when initializing scene).
func set_pressed_no_signal(p_pressed: bool) -> void:
	if not is_blocking_signals():
		set_block_signals(true)
		self.button_pressed = p_pressed
		_touch_index = -1
		_was_pressed_by_mouse = false
		set_block_signals(false)
	self.button_pressed = p_pressed
	_touch_index = -1
	_was_pressed_by_mouse = false


## Called when the button is pressed. If you need to know the button's pressed state (and [member toggle_mode] is active), use [method _toggled] instead.
func _pressed() -> void: pass


## Called when the button is toggled (only if [member toggle_mode] is active).
func _toggled(toggled_on: bool) -> void: pass


func _on_resized():
	pivot_offset = size / 2


func _get_configuration_warnings():
	var warn = []
	if is_instance_valid(button_group) and !is_toggle_mode():
		warn += [tr("ButtonGroup is intended to be used only with buttons that have toggle_mode set to true.")]
	return warn


func _has_point(point: Vector2) -> bool:
	return get_global_rect().has_point(point)


var _redraw_timer := 0.0
const _REDRAW_FRAMES = 10


func _process(delta: float) -> void:
	_redraw_timer += delta
	if _redraw_timer >= 1 / _REDRAW_FRAMES:
		queue_redraw()
		_redraw_timer -= 1 / _REDRAW_FRAMES


func _unpress_group():
	if is_instance_valid(button_group):
		for button: TouchBaseButton in button_group.get_buttons():
			if button == self:
				continue
			if button.is_toggle_mode():
				button.set_pressed_no_signal(false)
				button._emit_released()


func _get_button_mask(index: int) -> int:
	print(String.num_int64(mouse_button_mask & (2 ** (index - 1)), 2))
	if index <= MOUSE_BUTTON_NONE:
		return 0
	return 2 ** (index - 1)
