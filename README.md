# touchbuttons-plugin-godot

Plugin for Godot 4 that represents touchscreen equivalents of some Control nodes with multitouch support.

### Installation
1. Download .ZIP from GitHub
2. Copy `addons/touch_buttons` folder into `addons` directory of your project
3. Enable plugin in ProjectSettings

Options `emulate_touch_from_mouse` and `emulate_mouse_from_touch` don't affect the workability of **TouchButtton**s, so it is not necessary to disable emulation.

### New Control-derived classes:
- [TouchBaseButton](./docs/touch_base_button.md) (abstract)
- [TouchButton](./docs/touch_button.md)
- [TouchCheckBox](./docs/touch_check_box.md)
- [TouchCheckButton](./docs/touch_check_box.md)
- [TouchTextureButton](./docs/touch_check_box.md)
- [TouchRange](./docs/touch_range.md) (abstract)
- [TouchSlider](./docs/touch_slider.md) (abstract)
- [TouchHSlider](./docs/touch_h_slider.md)
- [TouchVSlider](./docs/touch_v_slider.md)


### New Resource-derived class:
- [TouchButtonGroup](./docs/touch_button_group.md)
