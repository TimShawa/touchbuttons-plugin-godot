# TouchBaseButton

[https://docs.godotengine.org/en/stable/classes/class_.html#]: #

**Inherits:** [Control](https://docs.godotengine.org/en/stable/classes/class_control.html#control) < [CanvasItem](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#canvasitem) < [Node](https://docs.godotengine.org/en/stable/classes/class_node.html#node) < [Object](https://docs.godotengine.org/en/stable/classes/class_object.html#object)

**Inherited By:** [TouchButton](./touch_button.md), [TouchTextureButton](./touch_texture_button.md)

A base class for touchscreen GUI buttons.

## Description

TouchBaseButton is base class for touchscreen GUI buttons. It doesn't display anything by itself. Multitouch-support included. Currently doesn't listen to [Shortcut](https://docs.godotengine.org/en/stable/classes/class_shortcut.html#shortcut) events.

There is no [BaseButton.toggle_mode](https://docs.godotengine.org/en/stable/classes/class_basebutton.html#class-basebutton-property-toggle-mode), but **TouchButton**s have a [press_mode](#pressmode-press_mode--0) property. Button can have "click", "toggle" or "pass-by" press mode. Click mode is the default button press mode, toggle is switching-state mode and the pass-by press mode allows the button to press on finger/mouse enter and release on the finger/mouse exit.

*Touchscreen equivalent of built-in [BaseButton]().*

## Properties
| Type | Property | Default Value |
|------|----------|---------------|
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) | [disabled](#bool-disabled--false) | `false` |
| [PressMode]() | [press_mode](#pressmode-press_mode--0) | `0` |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) | [button_pressed](#bool-button_pressed--false) | `false` |
| [ActionMode]() | [action_mode](#actionmode-action_mode--1) | `1` |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) | [pass_screen_drag](#bool-pass_screen_drag--false) | `false` |
| [TouchButtonGroup](./touch_button_group.md) | [button_group](#touchbuttongroup-button_group) |  |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) | [mouse_enabled](#bool-mouse_enabled--true) | `true` |
| BitField<[MouseButtonMask]()> | [mouse_button_mask](#bitfieldmousebuttonmask-mouse_button_mask--1) | `true` |

## Methods
| Return Type | Method |
|-------------|--------|
| void | [_pressed](#void-_pressed---virtual) ( ) _virtual_ |
| void | [_toggled](#void-_toggled--bool-toggled_on--virtual) ( [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) toggled_on ) _virtual_ |
| [DrawMode]() | [get_draw_mode]() ( ) _const_ |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) | [get_passby_press]() ( ) _const_ |
| [int](https://docs.godotengine.org/en/stable/classes/class_int.html#class-int) | [get_touch_index]() ( ) _const_ |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) | [is_hovered]() ( ) _const_ |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) | [is_toggle_mode]() ( ) _const_ |
| void | [set_pressed_no_signal]() ( [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) p_pressed ) |

---

## Signals

#### button_down ( )

- Emitted when the button starts being held down.

#### button_up ( )

- Emitted when the button stops being held down.

#### drag_input ( [InputEventScreenDrag](https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html#inputeventscreendrag) event )

- Emitted when the button forwards recieved [InputEventScreenDrag](https://docs.godotengine.org/en/stable/classes/class_inputeventscreendrag.html#inputeventscreendrag).

#### pressed ( )

- Emitted when the button is toggled or pressed. This is on [button_down](#button_down--) if [action_mode](#actionmode-action_mode--1) is ActionMode.ACTION_MODE_BUTTON_PRESS and on [button_up](#button_up--) otherwise.

  If you need to know the button's pressed state (and button isn't in "click" mode), use [toggled](#toggled--bool-toggled_on-) instead.

#### toggled ( [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#class-bool) toggled_on )

- Emitted when the button was just toggled between pressed and normal states (will not work in "click" mode). The new state is contained in the `toggled_on` argument.


---


## Enumerations


#### enum ActionMode:

- [ActionMode]() **ACTION_MODE_BUTTON_PRESS** = 0
  - Require just a press to consider the button clicked.

- [ActionMode]() **ACTION_MODE_BUTTON_RELEASE** = 1
  - Require a press and a subsequent release before considering the button clicked.


#### enum  PressMode:

- [PressMode]() **MODE_CLICK** = 0
  - The default button press mode. The button become pressed on screen touch (or on the mouse button press) and become released on finger up (or mouse button release).

- [PressMode]() **MODE_TOGGLE** = 1
  - The toggle press mode of a button. The button switch the state between pressed or released on any finger touch (or mouse button click).

- [PressMode]() **MODE_PASSBY_PRESS** = 2
  - The pass-by press mode of a button. The pressed and released signals are emitted whenever a pressed finger goes in and out of the button, even if the pressure started outside the active area of the button.


#### enum  DrawMode:

- [DrawMode]() **DRAW_NORMAL** = 0
  - The normal state (i.e. not pressed, not hovered, not toggled and enabled) of buttons.

- [DrawMode]() **DRAW_HOVER** = 1
  - The state of buttons are hovered.

- [DrawMode]() **DRAW_PRESSED** = 2
  - The state of buttons are pressed.

- [DrawMode]() **DRAW_DISABLED** = 3
  - The state of buttons are .

- [DrawMode]() **DRAW_HOVER_PRESSED** = 4
  - The state of buttons are both hovered and pressed.


---


## Property Descriptions


#### [bool]()  = `false`
> - void **set_disabled ( [bool]()** value **)**
> - **[bool]() is_disabled ( )**
- If `true`, the button is in disabled state and can't be clicked, hovered or toggled.


#### [PressMode]() press_mode = `0`
> - void **set_press_mode ( [PressMode]()** value **)**
> - **[PressMode]() get_press_mode ( )**
- Defines how the button reacts on input events. See [PressMode]() for more information about button press modes.


#### [bool]() button_pressed = `false`
> - void **set_button_pressed ( [bool]()** value **)**
> - **[bool]() is_button_pressed ( )**
- If `true`, the button's state is pressed. If you want to change the pressed state without emitting signals, use [set_pressed_no_signal()]().


#### [ActionMode]() action_mode = `1`
> - void **set_action_mode ( [ActionMode]()** value **)**
> - **[ActionMode]() get_action_mode ( )**
- Determines when the button is considered clicked, one of the [ActionMode]() constants.


#### [bool]() pass_screen_drag = `false`
> - void **set_pass_screen_drag ( [bool]()** value **)**
> - **[bool]() get_pass_screen_drag ( )**
- If `true`, the button will forward any recieved [InputEventScreenDrag]() with [drag_input]() signal. Works only when [press_mode](#pressmode-press_mode--0) is [PressMode.MODE_CLICK[]


#### [TouchButtonGroup]() button_group
> - void **set_button_group ( [TouchButtonGroup]()** value **)**
> - **[TouchButtonGroup]() get_button_group ( )**
- The [TouchButtonGroup] associated with the button. Not to be confused with node groups.

  **Note:** The button will be configured as a radio button if a [TouchButtonGroup] is assigned to it.


#### [bool]() mouse_enabled = `true`
> - void **set_mouse_enabled ( [bool]()** value **)**
> - **[bool]() is_mouse_enabled ( )**
- If `true` (by default), the button will respond to mouse clicks. Mouse button mask is defined by [mouse_button_mask](#bitfieldmousebuttonmask-mouse_button_mask--1) property.


#### BitField<[MouseButtonMask]()> mouse_button_mask = `1`
> - void **set_mouse_button_mask (** BitField<**[MouseButtonMask]()**> value **)**
> - BitField<**[MouseButtonMask]()**> **get_mouse_button_mask ( )**
- Binary mask to choose which mouse buttons this button will respond to. Makes sense only if [mouse_enabled](#bool-mouse_enabled--true) is true.

  To allow both left-click and right-click, use `MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT.`


---


## Method Descriptions


#### void _pressed ( ) _virtual_
- Called when the button is pressed. If you need to know the button's pressed state (and the button isn't in "click" mode), use [_toggled()](#void-_toggled--bool-toggled_on--virtual)] instead.


#### void _toggled ( [bool]() toggled_on ) _virtual_
- Called when the button is toggled (will not be emitted automatically in "click" mode).


#### [DrawMode]() get_draw_mode ( ) _const_
- Returns the visual state used to draw the button. This is useful mainly when implementing your own draw code by either overriding [_draw()]() or connecting to "draw" signal. The visual state of the button is defined by the [DrawMode]() enum.


#### [bool]() get_passby_press ( ) _const_
- Returns `true` if the button is in the pass-by press mode ([press_mode](#pressmode-press_mode--0) is [PressMode.MODE_PASSBY_PRESS]()).


#### [Variant]() get_touch_index ( ) _const_
- If button was pressed by touch, returns the touch index, -1 otherwise.


#### [bool]() is_hovered ( ) _const_
- Returns `true` if the button is hovered by mouse cursor. If [mouse_enabled](#bool-mouse_enabled--true) is `false`, this method will also return `false`


#### [bool]() is_toggle_mode ( ) _const_
- Returns `true` if the button is in the toggle mode ([press_mode](#pressmode-press_mode--0) is [PressMode.MODE_TOGGLE]()).


#### void set_pressed_no_signal ( [bool]() p_pressed )
- Changes the [button_pressed](#bool-button_pressed--false) state of the button, without emitting [toggled](). Use when you just want to change the state of the button without sending the [pressed]() event (e.g. when initializing scene).

  **Note:** This method doesn't unpress other buttons in [button_group](#touchbuttongroup-button_group).
