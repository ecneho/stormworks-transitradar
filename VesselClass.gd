class_name Vessel

var id: String
var positions: Array[Vector2]
var altitudes: Array[float]

var flag_ref: String
var flag_refs = {
	"it": "res://flags/it.svg",
	"gr": "res://flags/gr.svg",
	"ua": "res://flags/ua.svg",
	"fr": "res://flags/fr.svg",
	"us": "res://flags/us.svg",
	"xx": "res://flags/xx.svg",
}

var vessel_ref: String
var vessel_refs = {
	"drn": "res://icons/drone.png",
	"hlc": "res://icons/helicopter.png",
	"pln": "res://icons/plane.png"
}

func _init(_id: String, _country: String, _vessel: String):
	id = _id
	positions = []
	flag_ref = flag_refs.get(_country, flag_refs["xx"])
	vessel_ref = vessel_refs.get(_vessel, vessel_refs["pln"])
	
func _to_string() -> String:
	return "[*] Vessel - id: " + id
	
func push_position(x: float, y: float) -> void:
	positions.append(Vector2(x, y))
	
func push_altitude(alt: float) -> void:
	altitudes.append(alt)

func get_last_pos():
	if positions.is_empty():
		return null
	return positions[-1]
