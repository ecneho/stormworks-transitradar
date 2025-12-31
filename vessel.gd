extends Node2D

@onready var map_sprite = $"../Map"
@onready var plane_group = $Plane
@onready var plane_sprite = $Plane/Image
@onready var plane_tooltip = $Plane/Tooltip/ID
@onready var flag = $Plane/Tooltip/Flag

var ves: Vessel = Vessel.new("DRN100", map_sprite, "it", "drn")

func _ready() -> void:
	plane_tooltip.text = ves.id
	flag.texture = load(ves.flag_ref)
	plane_sprite.texture = load(ves.vessel_ref)
	pass

var altitude_colors = [
	{ "alt":    0,  "color": Color(0.94118, 0.39216, 0.07843) },
	{ "alt":  600,  "color": Color(0.94118, 0.62745, 0.11765) },
	{ "alt": 1200,  "color": Color(0.90196, 0.74510, 0.09804) },
	{ "alt": 1800,  "color": Color(0.74510, 0.78431, 0.05882) },
	{ "alt": 2400,  "color": Color(0.33333, 0.78431, 0.05882) },
	{ "alt": 3000,  "color": Color(0.12941, 0.76471, 0.21569) },
	{ "alt": 6000,  "color": Color(0.05882, 0.70588, 0.78431) },
	{ "alt": 9000,  "color": Color(0.23529, 0.21569, 0.94118) },
	{ "alt": 12000, "color": Color(0.78431, 0.05882, 0.78431) },
]

func get_color_for_altitude(alt: float) -> Color:
	if alt <= altitude_colors[0]["alt"]:
		return altitude_colors[0]["color"]
	for i in range(altitude_colors.size() - 1):
		var a0 = altitude_colors[i]["alt"]
		var a1 = altitude_colors[i + 1]["alt"]
		if alt <= a1:
			var t = float(alt - a0) / float(a1 - a0)
			return altitude_colors[i]["color"].lerp(altitude_colors[i + 1]["color"], t)
	return altitude_colors[-1]["color"]

func _draw():
	var points = ves.positions
	var altitudes = ves.altitudes
	
	for coord in points:
		draw_circle(coord, 2, Color.RED)
	
	var colors: Array[Color] = []
	for i in range(points.size()):
		colors.append(get_color_for_altitude(altitudes[i]))

	draw_polyline_colors(points, colors, 2.0)

func _process(delta: float) -> void:
	var last_pos = ves.get_last_pos()
	if last_pos == null: return
	
	plane_group.position = last_pos
	if (ves.positions.size() > 1):
		plane_sprite.look_at(ves.positions[-2])
	queue_redraw()
