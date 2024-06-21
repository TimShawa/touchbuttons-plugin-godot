@tool
class_name TouchTextureButton extends TouchBaseButton


enum StretchMode {
	STRETCH_SCALE,
	STRETCH_TILE,
	STRETCH_KEEP,
	STRETCH_KEEP_CENTERED,
	STRETCH_KEEP_ASPECT,
	STRETCH_KEEP_ASPECT_CENTERED,
	STRETCH_KEEP_ASPECT_COVERED
}

@export var ignore_texture_size := false: set = set_ignore_texture_size
@export_enum("Scale", "Tile", "Keep", "Keep Centered", "Keep Aspect", "Keep Aspect Centered", "Keep Aspect Covered") \
	var stretch_mode: int = StretchMode.STRETCH_KEEP
@export var flip_h := false
@export var flip_v := false

@export_group("Textures")
@export var texture_normal: Texture: set = set_texture_normal
@export var texture_pressed: Texture: set = set_texture_pressed
@export var texture_disabled: Texture: set = set_texture_disabled
@export var texture_click_mask: BitMap: set = set_texture_click_mask


var _texture_region := Rect2()
var _position_rect := Rect2()
var _tile := false


# == Property Setters ====

func set_ignore_texture_size(value):
	ignore_texture_size = value
	update_minimum_size()


func set_texture_normal(value):
	texture_normal = value
	_texture_changed()


func set_texture_pressed(value):
	texture_pressed = value
	_texture_changed()


func set_texture_disabled(value):
	texture_disabled = value
	_texture_changed()


func set_texture_click_mask(value):
	texture_click_mask = value
	_texture_changed()

# ==============


func _notification(p_what: int) -> void:
	match p_what:
		NOTIFICATION_DRAW:
			var draw_mode: int = get_draw_mode();
			
			var texdraw: Texture2D
			
			match draw_mode:
				DrawMode.DRAW_NORMAL:
					if is_instance_valid(texture_normal):
						texdraw = texture_normal
				DrawMode.DRAW_PRESSED:
					if texture_pressed == null:
						if is_instance_valid(texture_normal):
							texdraw = texture_normal
					else:
						texdraw = texture_pressed
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


func has_point(p_point: Vector2):
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
	
	return _in_rect(p_point)
