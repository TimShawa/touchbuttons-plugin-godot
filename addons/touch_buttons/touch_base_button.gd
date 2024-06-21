@tool
class_name TouchBaseButton extends Control


## Abstract base class for touchscreen GUI buttons.
## 
## TouchBaseButton is an abstract base class for touchscreen GUI buttons. It doesn't display anything by itself.
## Multitouch-support included. Doesn't listen for mouse events, only for screed touches and drag.

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
enum DrawMode {
	## The normal state (i.e. not pressed, not toggled and enabled) of buttons.
	DRAW_NORMAL,
	## The state of buttons are pressed.
	DRAW_PRESSED,
	## The state of buttons are disabled.
	DRAW_DISABLED
}

## If true, the button is in disabled state and can't be clicked or toggled.
var disabled := false: set = set_disabled
## If true, the button is in toggle mode. Makes the button flip state between pressed and unpressed each time its area is clicked.
var toggle_mode := false: set = set_toggle_mode
## If [code]true[/code], the button's state is pressed. If you want to change the pressed state without emitting signals, use [method set_pressed_no_signal].
var button_pressed := false: set = set_button_pressed
## Determines when the button is considered clicked, one of the [enum ActionMode] constants.
var action_mode: int = ActionMode.ACTION_MODE_BUTTON_RELEASE
## If [code]true[/code], the button is to be pressed only when any finger is in button's clickable area. It will not work when [member toggle_mode] is on.
var passby_press := false
## If [code]true[/code], the button will forward any recieved [class InputEventScreenDrag] with its own [signal drag_input] signal.
var pass_screen_drag := false
## The [class TouchButtonGroup] associated with the button. Not to be confused with node groups.[br]
## [br]
## [b]Note:[/b] The button will be configured as a radio button if a [class TouchButtonGroup] is assigned to it.
var button_group: TouchButtonGroup: set = set_button_group

func _get_property_list():
	return [
		{ name = "disabled", type = TYPE_BOOL },
		{ name = "toggle_mode", type = TYPE_BOOL },
		{ name = "button_pressed", type = TYPE_BOOL },
		{ name = "action_mode", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Button Press,Button Release" },
		{ name = "passby_press", type = TYPE_BOOL },
		{ name = "pass_screen_drag", type = TYPE_BOOL },
		{ name = "button_group", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "TouchButtonGroup" }
	]

## If button was pressed by touch, equals to touch index, -1 otherwise.
var touch_index := -1

# == Property setters ====

func set_toggle_mode(value):
	toggle_mode = value
	button_pressed = false
	update_configuration_warnings()


func set_disabled(value):
	disabled = value
	if disabled:
		button_pressed = false


func set_button_pressed(value):
	if value:
		button_pressed = true
		_emit_pressed()
	else:
		if toggle_mode and is_instance_valid(button_group):
			if !button_group.allow_unpress and !value:
				return
		button_pressed = false
		touch_index = -1
		_emit_released()


func _emit_pressed():
	if button_pressed:
		return
	
	emit_signal("button_down")
	emit_signal("toggled", true)
	
	if action_mode == ActionMode.ACTION_MODE_BUTTON_PRESS:
		emit_signal("pressed")
	
	if toggle_mode and is_instance_valid(button_group):
		button_group.emit_signal("pressed", self)


func _emit_released():
	if !button_pressed:
		return
	
	if toggle_mode and is_instance_valid(button_group):
		if !button_group.allow_unpress:
			return
	
	emit_signal("button_up")
	emit_signal("toggled", false)
	
	if action_mode == ActionMode.ACTION_MODE_BUTTON_PRESS:
		emit_signal("pressed")
		
	if toggle_mode and is_instance_valid(button_group):
		button_group.emit_signal("pressed", null)


func set_button_group(value):
	if button_group == value:
		return
	if is_instance_valid(button_group):
		button_group._buttons.erase(self)
		button_group.pressed.disconnect(_on_group_button_pressed)
	button_group = value
	if is_instance_valid(value):
		if !(self in button_group._buttons):
			button_group._buttons.push_back(self)
			if !button_group.pressed.is_connected(_on_group_button_pressed):
				button_group.pressed.connect(_on_group_button_pressed)
	update_configuration_warnings()


func _on_group_button_pressed(button: TouchBaseButton):
	if button != self:
		set_pressed_no_signal(false)

# ========================


func _init() -> void:
	if !pressed.is_connected(_pressed):
		pressed.connect(_pressed)
	if !toggled.is_connected(_toggled):
		toggled.connect(_toggled)
	if !resized.is_connected(_on_resized):
		resized.connect(_on_resized)


func _input(event: InputEvent) -> void:
	if disabled:
		return
	if !Engine.is_editor_hint():
		# REGULAR
		if !toggle_mode and !passby_press:
			if event is InputEventScreenTouch:
				if event.pressed:
					if _in_rect(event.position):
						if !button_pressed:
							touch_index = event.index
						if event.index == touch_index:
							self.button_pressed = true
#						else:
#							self.button_pressed = false
				if touch_index == event.index and !event.pressed:
					self.button_pressed = false
			# Pass drag events to, as examle, look controller panel
			if pass_screen_drag:
				if event is InputEventScreenDrag:
					if button_pressed and event.index == touch_index:
						emit_signal("drag_input", event)
		# PASS-BY
		elif !toggle_mode and passby_press:
			# Touch
			if event is InputEventScreenTouch:
				if event.is_pressed() and !event.is_echo():
					if _in_rect(event.position):
						if !button_pressed:
							touch_index = event.index
						if event.index == touch_index:
							self.button_pressed = true
						else:
							self.button_pressed = false
				if event.is_released() and event.index == touch_index:
					self.button_pressed = false
			# Drag
			if event is InputEventScreenDrag:
				if !button_pressed:
					if _in_rect(event.position):
						self.button_pressed = true
						touch_index = event.index
				elif event.index == touch_index:
					if !_in_rect(event.position):
						self.button_pressed = false
		# TOGGLE
		if toggle_mode and !passby_press:
				if event is InputEventScreenTouch:
					if event.is_pressed():
						if _in_rect(event.position):
							if !button_pressed:
								touch_index = event.index
							if event.index == touch_index:
								if button_pressed:
									self.button_pressed = false
								else:
									self.button_pressed = true


## Returns the visual state used to draw the button. This is useful mainly when implementing your own draw code by either overriding [method _draw] or connecting to "draw" signal.
## The visual state of the button is defined by the [enum DrawMode] enum.
func get_draw_mode() -> int:
	if disabled:
		return DrawMode.DRAW_DISABLED
	if button_pressed:
		return DrawMode.DRAW_PRESSED
	return DrawMode.DRAW_NORMAL


## Changes the button_pressed state of the button, without emitting [signal toggled].
## Use when you just want to change the state of the button without sending the pressed event (e.g. when initializing scene).
func set_pressed_no_signal(p_pressed: bool) -> void:
	self.button_pressed = p_pressed


## Called when the button is pressed. If you need to know the button's pressed state (and [member toggle_mode] is active), use [method _toggled] instead.
func _pressed() -> void: pass


## Called when the button is toggled (only if [member toggle_mode] is active).
func _toggled(toggled_on: bool) -> void: pass


func _on_resized():
	pivot_offset = size / 2


func _in_rect(point: Vector2, global := true):
	if global:
		return get_global_rect().has_point(point)
	return get_rect().has_point(point)


func _get_configuration_warning():
	if is_instance_valid(button_group) and !toggle_mode:
		return tr("ButtonGroup is intended to be used only with buttons that have toggle_mode set to true.")
	return ""


var _redraw_timer := 0.0
const _REDRAW_FRAMES = 10


func _process(delta: float) -> void:
	_redraw_timer += delta
	#printt(roundi(1 / delta), roundi(_REDRAW_FRAMES))
	if _redraw_timer >= 1 / _REDRAW_FRAMES:
		queue_redraw()
		_redraw_timer -= 1 / _REDRAW_FRAMES
