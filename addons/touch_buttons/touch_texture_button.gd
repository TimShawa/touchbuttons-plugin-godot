@tool
class_name TouchTextureButton extends TouchBaseButton


## Texture-based touchscreen button. Supports Pressed, and Disabled states.
## 
## [TouchTextureButton] has the same functionality as [TouchButton], except it uses sprites instead of Godot's [Theme] resource.
## It is faster to create, but it doesn't support localization like more complex [Control]s. It also support multitouch input.[br]
## [br]
## The "normal" state must contain a texture ([member texture_normal]); other textures are optional.[br]
## [br]
## See also [TouchBaseButton] which contains common properties and methods associated with this node.[br]
## [br]
## [i]Touchscreen equivalent of built-in [TextureButton].[/i]


enum StretchMode {
	## Scale to fit the node's bounding rectangle.
	STRETCH_SCALE,
	## Tile inside the node's bounding rectangle.
	STRETCH_TILE,
	## The texture keeps its original size and stays in the bounding rectangle's top-left corner.
	STRETCH_KEEP,
	## The texture keeps its original size and stays centered in the node's bounding rectangle
	STRETCH_KEEP_CENTERED,
	## Scale the texture to fit the node's bounding rectangle, but maintain the texture's aspect ratio.
	STRETCH_KEEP_ASPECT,
	## Scale the texture to fit the node's bounding rectangle, center it, and maintain its aspect ratio.
	STRETCH_KEEP_ASPECT_CENTERED,
	## Scale the texture so that the shorter side fits the bounding rectangle. The other side clips to the node's limits.
	STRETCH_KEEP_ASPECT_COVERED
}


## If [code]true[/code], the size of the texture won't be considered for minimum size calculation, so the [TouchTextureButton] can be shrunk down past the texture size.
var ignore_texture_size := false:
	set = set_ignore_texture_size, get = get_ignore_texture_size

## Controls the texture's behavior when you resize the node's bounding rectangle. See the [enum StretchMode] constants for available options.
var stretch_mode := StretchMode.STRETCH_KEEP:
	set = set_stretch_mode, get = get_stretch_mode

## If [code]true[/code], texture is flipped horizontally.
var flip_h := false:
	set = set_flip_h, get = is_fliped_h

## If [code]true[/code], texture is flipped vertically.
var flip_v := false:
	set = set_flip_v, get = is_fliped_v


## Texture to display by default, when the node is [b]not[/b] in the disabled or pressed state.
var texture_normal: Texture2D:
	set = set_texture_normal, get = get_texture_normal

## Texture to display when the mouse hovers the node.
var texture_hover: Texture2D:
	set = set_texture_hover, get = get_texture_hover

## Texture to display when the node is pressed.
var texture_pressed: Texture2D:
	set = set_texture_pressed, get = get_texture_pressed

## Texture to display when the node is disabled. See [memeber BaseButton.disabled].
var texture_disabled: Texture2D:
	set = set_texture_disabled, get = get_texture_disabled

## Texture to display when the node has mouse or keyboard focus.
## [member texture_focused] is displayed [i]over[/i] the base texture, so a partially transparent texture should be used to ensure the base texture remains visible.
## A texture that represents an outline or an underline works well for this purpose.
## To disable the focus visual effect, assign a fully transparent texture of any size.
## Note that disabling the focus visual effect will harm keyboard/controller navigation usability, so this is not recommended for accessibility reasons.
var texture_focused: Texture2D:
	set = set_texture_focused, get = get_texture_focused

## Pure black and white [BitMap] image to use for click detection.
## On the mask, white pixels represent the button's clickable area. Use it to create buttons with curved shapes.
var texture_click_mask: BitMap:
	set = set_texture_click_mask, get = get_texture_click_mask


func _get_property_list():
	return [
		{ name = "ignore_texture_size", type = TYPE_BOOL },
		{ name = "stretch_mode", type = TYPE_INT, hint = PROPERTY_HINT_ENUM, hint_string = "Scale,Tile,Keep,Keep Centered,Keep Aspect,Keep Aspect Centered,Keep Aspect Covered" },
		{ name = "flip_h", type = TYPE_BOOL },
		{ name = "flip_v", type = TYPE_BOOL },
		{ name = "Textures", type = TYPE_NIL, usage = PROPERTY_USAGE_GROUP },
		{ name = "texture_normal", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "Texture2D" },
		{ name = "texture_pressed", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "Texture2D" },
		{ name = "texture_hover", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "Texture2D" },
		{ name = "texture_disabled", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "Texture2D" },
		{ name = "texture_focused", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "Texture2D" },
		{ name = "texture_click_mask", type = TYPE_OBJECT, hint = PROPERTY_HINT_RESOURCE_TYPE, hint_string = "BitMap" }
	]


var _texture_region := Rect2()
var _position_rect := Rect2()
var _tile := false


#region SETGET

func set_ignore_texture_size(value):
	ignore_texture_size = value
	update_minimum_size()


func set_stretch_mode(value): stretch_mode = value


func set_flip_h(value): flip_h = value


func set_flip_v(value): flip_v = value


func set_texture_normal(value):
	texture_normal = value
	_texture_changed()


func set_texture_pressed(value):
	texture_pressed = value
	_texture_changed()


func set_texture_hover(value):
	texture_hover = value
	_texture_changed()


func set_texture_disabled(value):
	texture_disabled = value
	_texture_changed()


func set_texture_focused(value):
	texture_focused = value
	_texture_changed()


func set_texture_click_mask(value):
	texture_click_mask = value
	_texture_changed()


func get_ignore_texture_size(): return ignore_texture_size
func get_stretch_mode(): return stretch_mode
func is_fliped_h(): return flip_h
func is_fliped_v(): return flip_v
func get_texture_normal(): return texture_normal
func get_texture_pressed(): return texture_pressed
func get_texture_hover(): return texture_hover
func get_texture_disabled(): return texture_disabled
func get_texture_focused(): return texture_focused
func get_texture_click_mask(): return texture_click_mask

#endregion


func _notification(p_what: int) -> void:
	match p_what:
		NOTIFICATION_DRAW:
			var draw_mode: int = get_draw_mode();
			if draw_mode == DrawMode.DRAW_HOVER_PRESSED:
				draw_mode = DrawMode.DRAW_PRESSED
			
			var texdraw: Texture2D
			
			match draw_mode:
				DrawMode.DRAW_NORMAL:
					if is_instance_valid(texture_normal):
						texdraw = texture_normal
				DrawMode.DRAW_PRESSED:
					if texture_pressed == null:
						if texture_hover == null:
							if is_instance_valid(texture_normal):
								texdraw = texture_normal
						else:
							texdraw = texture_hover
					else:
						texdraw = texture_pressed
				DrawMode.DRAW_HOVER:
					if texture_hover == null:
						if is_instance_valid(texture_pressed) and is_button_pressed():
							texdraw = texture_pressed
						elif is_instance_valid(texture_normal):
							texdraw = texture_normal
					else:
						texdraw = texture_hover
				DrawMode.DRAW_DISABLED:
					if texture_disabled == null:
						if is_instance_valid(texture_normal):
							texdraw = texture_normal
					else:
						texdraw = texture_disabled
			
			var ofs: Vector2
			var size: Vector2
			
			if is_instance_valid(texdraw):
				size = texdraw.get_size()
				_texture_region = Rect2(Vector2(), texdraw.get_size())
				_tile = false
				match self.stretch_mode:
					StretchMode.STRETCH_KEEP:
						size = texdraw.get_size()
					StretchMode.STRETCH_SCALE:
						size = self.size
					StretchMode.STRETCH_TILE:
						size = self.size
						_tile = true
					StretchMode.STRETCH_KEEP_CENTERED:
						ofs = (self.size - texdraw.get_size()) / 2
						size = texdraw.get_size()
					StretchMode.STRETCH_KEEP_ASPECT:
						var _size := self.size
						var tex_width: float = texdraw.get_width() * _size.y / texdraw.get_height()
						var tex_height: float = _size.y
						if tex_width > _size.x:
							tex_width = _size.x
							tex_height = texdraw.get_height() * tex_width / texdraw.get_width()
						size.x = tex_width
						size.y = tex_height
					StretchMode.STRETCH_KEEP_ASPECT_CENTERED:
						var _size := self.size
						var tex_width: float = texdraw.get_width() * _size.y / texdraw.get_height()
						var tex_height: float = _size.y
						if tex_width > _size.x:
							tex_width = _size.x
							tex_height = texdraw.get_height() * tex_width / texdraw.get_width()
						ofs.x = (_size.x - tex_width) / 2
						ofs.y = (_size.y - tex_height) / 2
						size.x = tex_width
						size.y = tex_height
					StretchMode.STRETCH_KEEP_ASPECT_COVERED:
						size = self.size
						var tex_size = texdraw.get_size()
						var scale_size := Vector2(size.x / tex_size.x, size.y / tex_size.y)
						var scale: float = scale_size.x if scale_size.x > scale_size.y else scale_size.y
						var scaled_tex_size = tex_size * scale
						var ofs2 = ((scaled_tex_size - size) / scale).abs() / 2.0
						_texture_region = Rect2(ofs2, size / scale)
				
				_position_rect = Rect2(ofs, size);
				
				size.x *= -1.0 if flip_h else 1.0
				size.y *= -1.0 if flip_v else 1.0
				
				if _tile:
					draw_texture_rect(texdraw, Rect2(ofs, size), _tile)
				else:
					draw_texture_rect_region(texdraw, Rect2(ofs, size), _texture_region)
			else:
				_position_rect = Rect2()


func _texture_changed():
	queue_redraw()
	update_minimum_size()


func _get_minimum_size():
	var rscale = Vector2()
	
	if (!ignore_texture_size):
		if texture_normal == null:
			if texture_pressed == null:
				if texture_click_mask == null:
					rscale = Vector2()
				else:
					rscale = texture_click_mask.get_size()
			else:
				rscale = texture_pressed.get_size()
		else:
			rscale = texture_normal.get_size()

	return rscale.abs()


func _has_point(p_point: Vector2):
	if is_instance_valid(texture_click_mask):
		var point := p_point
		var rect: Rect2
		var mask_size = texture_click_mask.get_size()
		
		if !_position_rect.has_area():
			rect.size = mask_size
		elif _tile:
			if _position_rect.has_point(point):
				var cols: int = ceil(_position_rect.size.x / mask_size.x)
				var rows: int = ceil(_position_rect.size.y / mask_size.y)
				var col: int = int(point.x / mask_size.x) % cols
				var row: int = int(point.y / mask_size.y) % rows
				point.x -= mask_size.x * col
				point.y -= mask_size.y * row
		else:
			var ofs: Vector2 = _position_rect.position
			var scale: Vector2 = mask_size / _position_rect.size
			if stretch_mode == StretchMode.STRETCH_KEEP_ASPECT_COVERED:
				var _min = min(scale.x, scale.y)
				scale.x = _min
				scale.y = _min
				ofs -= _texture_region.position / _min
			
			point -= ofs
			point *= scale
			
			rect.position = Vector2(max(0, _texture_region.position.x), max(0, _texture_region.position.y))
			rect.size = Vector2(min(mask_size.x, _texture_region.size.x), min(mask_size.y, _texture_region.size.y))
		
		if !rect.has_point(point):
			return false
		
		return texture_click_mask.get_bitv(point)
	
	return get_global_rect().has_point(p_point)
