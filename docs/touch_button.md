# TouchButton

**Inherits:** [TouchBaseButton](./touch_base_button.md) < [Control](https://docs.godotengine.org/en/stable/classes/class_control.html#control) < [CanvasItem](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html#canvasitem) < [Node](https://docs.godotengine.org/en/stable/classes/class_node.html#node) < [Object](https://docs.godotengine.org/en/stable/classes/class_object.html#object)

**Inherited By:** [TouchCheckBox](./touch_check_box.md), [TouchCheckButton](./touch_check_button.md)

A themed button that can contain text and an icon.

## Description

**TouchButton** is the standard themed touchscreen button. It can contain text and an icon, and it will display them according to the current [Theme](https://docs.godotengine.org/en/stable/classes/class_theme.html#theme).
**Example of creating a button and assigning an action when pressed by code:**

    func _ready():
        var button = Button.new()
        button.text = "Click me"
        button.pressed.connect(self._button_pressed)
        add_child(button)
    
    func _button_pressed():
        print("Hello world!")

See also [TouchBaseButton](./touch_base_button.md) which contains common properties and methods associated with this node.

**TouchButton**s ACTUALLY interpret touch input and support multitouch, unlike built-in [Button](https://docs.godotengine.org/en/stable/classes/class_button.html#button)s. To change button appearance attach [Theme](https://docs.godotengine.org/en/stable/classes/class_theme.html#theme) resourse to the node and modify its parameters. Also custom [theme_type_variation](https://docs.godotengine.org/en/stable/classes/class_control.html#class-control-property-theme-type-variation) will be used, if specified. [Theme](https://docs.godotengine.org/en/stable/classes/class_theme.html#theme) properties and default values can be found at `res://addons/touch_buttons/buttons_theme.tres`.

_Touchscreen equivalent of buiilt-in [Button](https://docs.godotengine.org/en/stable/classes/class_button.html#button)._


## Properties
| Type | Property | Default Value |
|------|----------|---------------|
| [String](https://docs.godotengine.org/en/stable/classes/class_string.html#string) | [text](#string-text--) | `""` |
| [Texture2D](https://docs.godotengine.org/en/stable/classes/class_texture2d.html#texture2d) | [icon](#texture2d-icon) |  |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) | [flat](#bool-flat--false) | `false` |
| [HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment) | [alignment](#horizontalalignment-alignment--0) | `1` |
| [TextServer.OverrunBehavior](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-overrunbehavior) | [text_overrun_behavior](#textserveroverrunbehavior-overrun_behavior--0) | `0` |
| [TextServer.AutowrapMode](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-autowrapmode) | [autowrap_mode](#textserverautowrapmode-autowrap_mode--0) | `0` |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) | [clip_text](#bool-clip_text--false) | `false` |
| [HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment) | [icon_alignment](#horizontalalignment-icon_alignment--false) | `0` |
| [VerticalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-verticalalignment) | [vertical_icon_alignment](#verticalalignment-vertical_icon_alignment--false) | `1` |
| [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) | [expand_icon](#bool-expand_icon--false) | `false` |
| [TextServer.Direction](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-direction) | [text_direction](#textserverdirection-text_direction--0) | `0` |
| [String](https://docs.godotengine.org/en/stable/classes/class_string.html#string) | [language](#string-language--) | `""` |


## Property Descriptions


#### [String](https://docs.godotengine.org/en/stable/classes/class_string.html#string) text = `""`
> - void **set_text ( [String](https://docs.godotengine.org/en/stable/classes/class_string.html#string)** value** **)**
> - **[String](https://docs.godotengine.org/en/stable/classes/class_string.html#string) get_text ( )**
- The button's text that will be displayed inside the button's area.


#### [Texture2D](https://docs.godotengine.org/en/stable/classes/class_texture2d.html#texture2d) icon
> - void **set_icon ( [Texture2D](https://docs.godotengine.org/en/stable/classes/class_texture2d.html#texture2d)** value **)**
> - **[Texture2D](https://docs.godotengine.org/en/stable/classes/class_texture2d.html#texture2d) get_icon ( )**
- Button's icon, if text is present the icon will be placed before the text. \
  To edit margin and spacing of the icon, use [h_separation](https://docs.godotengine.org/en/stable/classes/class_button.html#class-button-theme-constant-h-separation) theme property and `content_margin_*` properties of the used [StyleBox](https://docs.godotengine.org/en/stable/classes/class_stylebox.html#stylebox)es.


#### [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) flat = `false`
> - void **set_flat ( [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool)** value **)**
> - **[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) is_flat ( )**
- Flat buttons don't display decoration.


#### [HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment) alignment = `0`
> - void **set_alignment ( [HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment)** value **)**
> - **[HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment) get_alignment ( )**
- Text alignment policy for the button's text, use one of the [HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment) constants.


#### [TextServer.OverrunBehavior](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-overrunbehavior) overrun_behavior = `0`
> - void **set_overrun_behavior ( [TextServer.OverrunBehavior](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-overrunbehavior)** value **)**
> - **[TextServer.OverrunBehavior](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-overrunbehavior) get_overrun_behavior ( )**
- Sets the clipping behavior when the text exceeds the node's bounding rectangle. See [TextServer.OverrunBehavior](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-overrunbehavior) for a description of all modes.


#### [TextServer.AutowrapMode](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-autowrapmode) autowrap_mode = `0`
> - void **set_autowrap_mode ( [TextServer.AutowrapMode](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-autowrapmode)** value **)**
> - **[TextServer.AutowrapMode](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-autowrapmode) get_autowrap_mode ( )**
- If set to something other than [TextServer](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-autowrapmode).AUTOWRAP_OFF, the text gets wrapped inside the node's bounding rectangle.


#### [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) clip_text = `false`
> - void **set_clip_text ( [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool)** value **)**
> - **[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) get_clip_text ( )**
- When this property is enabled, text that is too large to fit the button is clipped, when disabled the **TouchButton** will always be wide enough to hold the text.


#### [HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment) icon_alignment = `false`
> - void **set_icon_alignment ( [HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment)** value **)**
> - **[HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment) get_icon_alignment ( )**
- Specifies if the icon should be aligned horizontally to the left, right, or center of a button. Uses the same [HorizontalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-horizontalalignment) constants as the text alignment. If centered horizontally and vertically, text will draw on top of the icon.


#### [VerticalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-verticalalignment) vertical_icon_alignment = `false`
> - void **set_vertical_icon_alignment ( [VerticalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-verticalalignment)** value **)**
> - **[VerticalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-verticalalignment) get_vertical_icon_alignment ( )**
- Specifies if the icon should be aligned vertically to the top, bottom, or center of a button. Uses the same [VerticalAlignment](https://docs.godotengine.org/en/stable/classes/class_@globalscope.html#enum-globalscope-verticalalignment) constants as the text alignment. If centered horizontally and vertically, text will draw on top of the icon.


#### [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) expand_icon = `false`
> - void **set_expand_icon ( [bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool)** value **)**
> - **[bool](https://docs.godotengine.org/en/stable/classes/class_bool.html#bool) is_expand_icon ( )**
- When enabled, the button's icon will expand/shrink to fit the button's size while keeping its aspect.


#### [TextServer.Direction](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-direction) text_direction = `0`
> - void **set_text_direction ( [TextServer.Direction](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-direction)** value **)**
> - **[TextServer.Direction](https://docs.godotengine.org/en/stable/classes/class_textserver.html#enum-textserver-direction) get_text_direction ( )**
- Base text writing direction.


#### [String](https://docs.godotengine.org/en/stable/classes/class_string.html#string) language = `""`
> - void **set_language ( [String](https://docs.godotengine.org/en/stable/classes/class_string.html#string)** value **)**
> - **[String](https://docs.godotengine.org/en/stable/classes/class_string.html#string) get_language ( )**
- Language code used for line-breaking and text shaping algorithms, if left empty current locale is used instead.


















