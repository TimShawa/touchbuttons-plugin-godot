@tool
class_name TouchVSlider extends TouchSlider

## A vertical toucscreen slider that goes from bottom (min) to top (max).
## 
## A vertical slider with multitouch support, used to adjust a value by moving a grabber along a vertical axis.
## It is a Range-based control and goes from bottom (min) to top (max).
## Note that this direction is the opposite of VScrollBar's.[br]
## [br]
## [i]Touchscreen equivalent of buiilt-in [VSlider].[/i]

func _init():
	_orientation = VERTICAL
	_theme_type = "TouchVSlider"
	size_flags_horizontal = 0
	size_flags_vertical = 1
