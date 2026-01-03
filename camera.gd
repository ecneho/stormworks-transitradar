extends Camera2D

@export var zoom_step := 1.1
@export var min_zoom := 0.0001
@export var max_zoom := 10.0

var dragging := false
var last_mouse_pos := Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		last_mouse_pos = event.position

	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position -= delta / zoom.x
		last_mouse_pos = event.position

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_set_zoom(1.0 / zoom_step)

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_set_zoom(zoom_step)

func _set_zoom(factor: float) -> void:
	var new_zoom := zoom * factor
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = new_zoom.x
	zoom = new_zoom
