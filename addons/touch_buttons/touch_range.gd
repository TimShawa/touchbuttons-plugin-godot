@tool
class_name TouchRange extends Control


## Base class for controls that represent a number within a range.
## 
## TouchRange is a base class for multitouch-supporting controls that represent a number within a range, using a configured [member step] and [member page] size. See [TouchSlider] for example of higher-level node using TouchRange.[br]
## [br]
## [i]Touchscreen equivalent of built-in [Range].[/i]


## Emitted when [member value] changes. When used on a [TouchSlider], this is called continuously while dragging (potentially every frame). If you are performing an expensive operation in a function connected to [signal value_changed], consider using a [i]debouncing[/i] [Timer] to call the function less often.[br]
## [br]
## [b]Note:[/b] Unlike signals such as [signal LineEdit.text_changed], [signal value_changed] is also emitted when [code]value[/code] is set directly via code.
signal value_changed(value: float)

## Emitted when [member min_value], [member max_value], [member page], or [member step] change.
signal changed


## Minimum value. Range is clamped if [member value] is less than [member min_value].
var min_value: float = 0.0:
	set = set_min, get = get_min

## Maximum value. Range is clamped if [member value] is greater than [member max_value].
var max_value: float = 100.0:
	set = set_max, get = get_max

## If greater than 0, [member value] will always be rounded to a multiple of this property's value. If rounded is also [code]true[/code], [member value] will first be rounded to a multiple of this property's value, then rounded to the nearest integer.
var step: float = 1:
	set = set_step, get = get_step

## Page size. Used mainly for [TouchScrollBar]. [TouchScrollBar]'s length is its size multiplied by [member page] over the difference between [member min_value] and [member max_value].
var page: float = 0:
	set = set_page, get = get_page

## Range's current value. Changing this property (even via code) will trigger [signal value_changed] signal. Use [method set_value_no_signal] if you want to avoid it.
var value: float = 0:
	set = set_value, get = get_value

## The value mapped between 0 and 1.
var ratio: float = 0.0:
	set = set_as_ratio, get = get_as_ratio

## If [code]true[/code], and [member min_value] is greater than 0, [member value] will be represented exponentially rather than linearly.
var exp_edit: bool = false:
	set = set_exp_ratio, get = is_ratio_exp

## If [code]true[/code], [member value] will always be rounded to the nearest integer.
var rounded: bool = false:
	set = set_use_rounded_values, get = is_using_rounded_values

## If [code]true[/code], [member value] may be greater than [member max_value].
var allow_greater: bool = false:
	set = set_allow_greater, get = is_greater_allowed

## If [code]true[/code], [member value] may be less than [member min_value].
var allow_lesser: bool = false:
	set = set_allow_greater, get = is_lesser_allowed


func _get_property_list():
	return [
		{ name = "min_value", type = TYPE_FLOAT },
		{ name = "max_value", type = TYPE_FLOAT },
		{ name = "step", type = TYPE_FLOAT },
		{ name = "value", type = TYPE_FLOAT },
		{
			name = "ratio", type = TYPE_FLOAT,
			hint = PROPERTY_HINT_RANGE, hint_string = "0,1,0.01",
			usage = PROPERTY_USAGE_NONE
		},
		{ name = "exp_edit", type = TYPE_BOOL },
		{ name = "rounded", type = TYPE_BOOL },
		{ name = "allow_greater", type = TYPE_BOOL },
		{ name = "allow_lesser", type = TYPE_BOOL }
	]


var _shared: _Shared = null
var _rounded_values = false


func _ref_shared(p_shared: _Shared) -> void:
	if _shared and p_shared == _shared:
		return
	_unref_shared()
	_shared = p_shared
	_shared.owners.push_back(self)


func _unref_shared() -> void:
	if _shared:
		_shared.owners.erase(self)
		if _shared.owners.size() == 0:
			_shared.free()
			_shared = null


func _share(p_range: Node) -> void:
	var r = p_range as Range
	if r != null:
		share(r)


func _value_changed_notify() -> void:
	_value_changed(_shared.val)
	value_changed.emit(_shared.val)
	queue_redraw()


func _changed_notify(p_what: String = "") -> void:
	changed.emit()
	queue_redraw()


func _set_value_no_signal(p_val: float) -> void:
	if !is_finite(p_val):
		return
	if _shared.step > 0:
		p_val = roundf((p_val - _shared.min) / _shared.step) * _shared.step + _shared.min
	if _rounded_values:
		p_val = round(p_val)
	if !_shared.allow_greater and p_val > _shared.max - _shared.page:
		p_val = _shared.max - _shared.page
	if !_shared.allow_lesser and p_val < _shared.min:
		p_val = _shared.min
	if _shared.val == p_val:
		return
	_shared.val = p_val


## Called when the [TouchRange]'s value is changed (following the same conditions as [signal value_changed]).
func _value_changed(p_value: float) -> void: pass


func _notify_shared_value_changed() -> void:
	_shared.emit_value_changed()


func set_value(p_val: float) -> void:
	var prev_val := _shared.val
	_set_value_no_signal(p_val)
	if _shared.val != prev_val:
		_shared.emit_value_changed()


## Sets the [TouchRange]'s current value to the specified [code]value[/code], without emitting the [signal value_changed] signal.
func set_value_no_signal(p_val: float) -> void:
	var prev_val = _shared.val
	_set_value_no_signal(p_val)
	if _shared.val != prev_val:
		_shared.redraw_owners()


func set_min(p_min: float) -> void:
	if _shared.min == p_min: return
	_shared.min = p_min
	_shared.max = maxf(_shared.max, _shared.min)
	_shared.page = clampf(_shared.page, 0, _shared.max - _shared.min)
	set_value(_shared.val)
	_shared.emit_changed("min")
	update_configuration_warnings()


func set_max(p_max: float) -> void:
	var max_validated = max(p_max, _shared.min)
	if _shared.max == max_validated:
		return
	_shared.max = max_validated
	_shared.page = clampf(_shared.page, 0, _shared.max - _shared.min)
	set_value(_shared.val)
	_shared.emit_changed("max")


func set_step(p_step: float) -> void:
	if _shared.step == p_step: return
	_shared.step = p_step
	_shared.emit_changed("step")


func set_page(p_page: float) -> void:
	var page_validated = clampf(p_page, 0, _shared.max - _shared.min)
	if _shared.page == page_validated: return
	_shared.page = page_validated
	set_value(_shared.val)
	_shared.emit_changed("page")


func set_as_ratio(p_value: float) -> void:
	var v: float
	if _shared.exp_ratio and get_min() >= 0:
		var exp_min = 0.0 if (get_min() == 0) else log(get_min()) / log(2.0)
		var exp_max = log(get_max()) / log(2.0)
	else:
		var percent = (get_max() - get_min()) * p_value
		if get_step() > 0:
			var steps = round(percent / get_step())
			v = steps * get_step() + get_min()
		else:
			v = percent + get_min()
	v = clampf(v, get_min(), get_max())
	set_value(v)


func get_value() -> float:
	return _shared.val


func get_min() -> float:
	return _shared.min


func get_max() -> float:
	return _shared.max


func get_step() -> float:
	return _shared.step


func get_page() -> float:
	return _shared.page


func get_as_ratio() -> float:
	if is_equal_approx(get_max(), get_min()):
		return 1.0
	if _shared.exp_ratio and get_min() >= 0:
		var exp_min = 0.0 if (get_min() == 0) else log(get_min()) / log(2.0)
		var exp_max = log(get_max()) / log(2.0)
		var value = clampf(get_value(), _shared.min, _shared.max)
		var v = log(value) / log(2.0)
		return clampf((v - exp_min) / (exp_max - exp_min), 0, 1)
	else:
		var value = clampf(get_value(), _shared.min, _shared.max)
		return clampf((value - get_min()) / (get_max() - get_min()), 0, 1)


func set_use_rounded_values(p_enable: bool) -> void:
	_rounded_values = p_enable


func is_using_rounded_values() -> bool:
	return _rounded_values


func set_exp_ratio(p_enable: bool) -> void:
	if _shared.exp_ratio == p_enable:
		return
	_shared.exp_ratio = p_enable
	update_configuration_warnings()


func is_ratio_exp() -> bool:
	return _shared.exp_ratio


func set_allow_greater(p_allow: bool) -> void:
	_shared.allow_greater = p_allow


func is_greater_allowed() -> bool:
	return _shared.allow_greater


func set_allow_lesser(p_allow: bool) -> void:
	_shared.allow_greater = p_allow


func is_lesser_allowed() -> bool:
	return _shared.allow_lesser


## Binds two [TouchRange]s together along with any ranges previously grouped with either of them. When any of range's member variables change, it will share the new value with all other ranges in its group.
func share(p_range: TouchRange) -> void:
	if p_range != null:
		p_range._ref_shared(_shared)
		p_range._changed_notify()
		p_range._value_changed_notify()


## Stops the [TouchRange] from sharing its member variables with any other.
func unshare() -> void:
	var nshared := _Shared.new()
	nshared.min = _shared.min
	nshared.max = _shared.max
	nshared.val = _shared.val
	nshared.step = _shared.step
	nshared.page = _shared.page
	nshared.exp_ratio = _shared.exp_ratio
	nshared.allow_greater = _shared.allow_greater
	nshared.allow_lesser = _shared.allow_lesser
	_unref_shared()
	_ref_shared(nshared)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray([])
	if _shared.exp_ratio and _shared.min <= 0:
		warnings.push_back(tr("If \"Exp Edit\" is enabled, \"Min Value\" must be greater than 0."))
	return warnings


func _init():
	_validate_shared()
	size_flags_vertical = 0

func _ready():
	_validate_shared()


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		_unref_shared()


class _Shared extends Object:
	var val: float = 0.0
	var min: float = 0.0
	var max: float = 100.0
	var step: float = 1.0
	var page: float = 0.0
	var exp_ratio: bool = false
	var allow_greater: bool = false
	var allow_lesser: bool = false
	var owners: Array[TouchRange]
	
	func emit_value_changed() -> void:
		for E: TouchRange in owners:
			if !E.is_inside_tree():
				continue
			E._value_changed_notify()
	
	func emit_changed(p_what: String = "") -> void:
		for E: TouchRange in owners:
			if !E.is_inside_tree():
				continue
			E._changed_notify(p_what)
	
	func redraw_owners() -> void:
		for E: TouchRange in owners:
			if !E.is_inside_tree():
				continue
			E.queue_redraw()


func _validate_shared():
	if !_shared:
		_shared = _Shared.new()
		_shared.owners.push_back(self)
