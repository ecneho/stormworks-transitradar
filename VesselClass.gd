class_name Vessel

var id: String
var positions: Array[Vector2]
var altitudes: Array[float]
var map_sprite: Sprite2D

var flag_ref: String
var flag_refs = {
	"it": "res://flags/it.svg",
	"xx": "res://flags/xx.svg"
}

var vessel_ref: String
var vessel_refs = {
	"drn": "res://icons/drone.png",
	"hlc": "res://icons/helicopter.png",
	"pln": "res://icons/plane.png"
}

func _init(_id: String, _map_sprite: Sprite2D, _country: String, _vessel: String):
	id = _id
	map_sprite = _map_sprite
	positions = []
	flag_ref = flag_refs.get(_country, flag_refs["xx"])
	vessel_ref = vessel_refs.get(_vessel, vessel_refs["pln"])
	
func _to_string() -> String:
	return "[*] Vessel - id: " + id
	
func push_position(x: float, y: float) -> void:
	positions.append(_external_to_godot(Vector2(x, y)))
	
func push_altitude(alt: float) -> void:
	altitudes.append(alt)

func get_last_pos():
	if positions.is_empty():
		return null
	return positions[-1]

func _external_to_godot(external_pos: Vector2) -> Vector2:
	var world_top_left = Vector2(-8500, -2500)
	var world_bottom_right = Vector2(11500, -12500)
	var actual_height = map_sprite.texture.get_height() * map_sprite.scale.y
	var actual_width = map_sprite.texture.get_width() * map_sprite.scale.x
	var offset_pos = external_pos - world_top_left
	var world_size = world_bottom_right - world_top_left
	var actual_scale = Vector2(actual_width / world_size.x, actual_height / abs(world_size.y))
	return Vector2(offset_pos.x * actual_scale.x, (-offset_pos.y) * actual_scale.y)
