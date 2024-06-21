@tool
class_name TouchBaseButton extends Control


signal button_down
signal button_up
signal pressed
signal toggled(toggled_on: bool)
signal drag_input(event)


enum ActionMode { ACTION_MODE_BUTTON_PRESS, ACTION_MODE_BUTTON_RELEASE }
enum DrawMode { DRAW_NORMAL, DRAW_PRESSED, DRAW_DISABLED }

@export
var disabled := false: set = set_disabled
@export
var toggle_mode := false: set = set_toggle_mode
@export
var button_pressed := false: set = set_button_pressed
@export_enum("Button Press", "Button Release")
var action_mode: int = ActionMode.ACTION_MODE_BUTTON_RELEASE
@export
var passby_press := false
@export
var pass_screen_drag := false
@export
var group: TouchButtonGroup: set = set_button_group

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
		if toggle_mode and is_instance_valid(group):
			if !group.allow_unpress and !value:
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
	
	if toggle_mode and is_instance_valid(group):
		group.emit_signal("pressed", self)


func _emit_released():
	if !button_pressed:
		return
	
	if toggle_mode and is_instance_valid(group):
		if !group.allow_unpress:
			return
	
	emit_signal("button_up")
	emit_signal("toggled", false)
	
	if action_mode == ActionMode.ACTION_MODE_BUTTON_PRESS:
		emit_signal("pressed")
		
	if toggle_mode and is_instance_valid(group):
		group.emit_signal("pressed", null)


func set_button_group(value):
	if group == value:
		return
	if is_instance_valid(group):
		group._buttons.erase(self)
		group.pressed.disconnect(_on_group_button_pressed)
	group = value
	if is_instance_valid(value):
		if !(self in group._buttons):
			group._buttons.push_back(self)
			if !group.pressed.is_connected(_on_group_button_pressed):
				group.pressed.connect(_on_group_button_pressed)
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


func get_draw_mode() -> int:
	if disabled:
		return DrawMode.DRAW_DISABLED
	if button_pressed:
		return DrawMode.DRAW_PRESSED
	return DrawMode.DRAW_NORMAL


func set_pressed_no_signal(p_pressed: bool) -> void:
	self.button_pressed = p_pressed


func _pressed() -> void: pass
func _toggled(toggled_on: bool) -> void: pass


func _on_resized():
	pivot_offset = size / 2


func _in_rect(point: Vector2, global := true):
	if global:
		return get_global_rect().has_point(point)
	return get_rect().has_point(point)


func _get_configuration_warning():
	if is_instance_valid(group) and !toggle_mode:
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
