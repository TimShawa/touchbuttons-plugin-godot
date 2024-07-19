# TouchButton

**Inherits:** [TouchBaseButton](./touch_base_button.md) < [Control](https://docs.godotengine.org/en/stable/classes/class_control.html#control) < [CanvasItem](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#canvasitem) < [Node](https://docs.godotengine.org/en/stable/classes/class_node.html#node) < [Object](https://docs.godotengine.org/en/stable/classes/class_object.html#object)

**Inherited By:** [TouchCheckBox](./touch_check_box.md), [TouchCheckButton](./touch_check_button.md)

A themed button that can contain text and an icon.

## Description

**TouchButton** is the standard themed touchscreen button. It can contain text and an icon, and it will display them according to the current [Theme]().
**Example of creating a button and assigning an action when pressed by code:**

    func _ready():
        var button = Button.new()
        button.text = "Click me"
        button.pressed.connect(self._button_pressed)
        add_child(button)
    
    func _button_pressed():
        print("Hello world!")

See also [TouchBaseButton]() which contains common properties and methods associated with this node.

**TouchButton**s ACTUALLY interpret touch input and support multitouch, unlike built-in [Button]()s. To change button appearance attach [Theme]() resourse to the node and modify its parameters. Also custom [theme_type_variation]() will be used, if specified. [Theme]() properties and default values can be found at `res://addons/touch_buttons/buttons_theme.tres`.

_Touchscreen equivalent of buiilt-in [Button]()._


## Properties
| Type | Property | Default Value |
|------|----------|---------------|
| [String]() | [text]() | `""` |
| [Texture2D]() | [icon]() |  |
| [bool]() | [flat]() | `false` |
| [HorizontalAlignment]() | [alignment]() | `1` |
| [TextServer.OverrunBehavior]() | [text_overrun_behavior]() | `0` |
| [TextServer.AutowrapMode]() | [autowrap_mode]() | `0` |
| [bool]() | [clip_text]() | `false` |
| [HorizontalAlignment]() | [icon_alignment]() | `0` |
| [VerticalAlignment]() | [vertical_icon_alignment]() | `1` |
| [bool]() | [expand_icon]() | `false` |
| [TextServer.Direction]() | [text_direction]() | `0` |
| [String]() | [language]() | `""` |


## Methods
| Return Type | Method |
|-------------|--------|
| void | [_pressed](#void-_pressed---virtual) ( ) _virtual_ |

---

## Signals

#### button_down ( )

- Emitted when the button starts being held down.


---


## Enumerations


#### enum ActionMode:

- [ActionMode](#enum-actionmode) **ACTION_MODE_BUTTON_PRESS** = 0
  - Require just a press to consider the button clicked.


---


## Property Descriptions


#### [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool)  = `false`
> - void **set_disabled ( [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool)** value **)**
> - **[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) is_disabled ( )**
- If `true`, the button is in disabled state and can't be clicked, hovered or toggled.


---


## Method Descriptions


#### void _pressed ( ) _virtual_
- Called when the button is pressed. If you need to know the button's pressed state (and the button isn't in "click" mode), use [_toggled()](#void-_toggled--bool-toggled_on--virtual)] instead.
