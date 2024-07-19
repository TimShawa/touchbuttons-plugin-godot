@tool
class_name TouchHSlider extends TouchSlider

## A horizontal touchscreen slider that goes from left (min) to right (max).
## 
## A horizontal slider with multitouch support, used to adjust a value by moving a grabber along a horizontal axis.
## It is a [Range]-based control and goes from left (min) to right (max).[br]
## [br]
## [i]Touchscreen equivalent of buiilt-in [HSlider].[/i]

func _init():
	_validate_shared()
	_orientation = HORIZONTAL
	_theme_type = "TouchHSlider"
	size_flags_horizontal = 1
	size_flags_vertical = 0
	focus_mode = Control.FOCUS_ALL
