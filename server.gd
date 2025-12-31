extends Node

var server := TCPServer.new()

func _ready():
	var port = 5000
	var err = server.listen(port)
	print("Server listening on port %d" % port)

var vessel_res: PackedScene = load("res://scenes/vessel.tscn")

func _process(delta):
	if server.is_connection_available():
		var client = server.take_connection()
		if client:
			var request_text = client.get_utf8_string(client.get_available_bytes())
			var query_params = parse_get_query(request_text)
			
			print(query_params)
			var id = query_params["id"]
			var country = query_params["cf"]
			var ves_type = query_params["vs"]
			var x = float(query_params["x"])
			var y = float(query_params["y"])
			var alt = float(query_params["alt"])
			
			# TODO: validation
			
			if not has_node(id):
				var res = vessel_res.instantiate()
				res.name = id
				res.ves = Vessel.new(id, $Map, country, ves_type)
				add_child(res)
				
			var ves_node = get_node(id)
			var vessel: Vessel = ves_node.ves
			
			vessel.push_position(x, y)
			vessel.push_altitude(alt)
			client.disconnect_from_host()

func parse_get_query(request_text: String) -> Dictionary:
	var result = {}
	var first_line = request_text.split("\n")[0]
	if first_line.begins_with("GET "):
		var parts = first_line.split(" ")
		if parts.size() >= 2:
			var path = parts[1]
			if "?" in path:
				var query = path.split("?")[1]
				for pair in query.split("&"):
					if "=" in pair:
						var kv = pair.split("=")
						result[kv[0]] = kv[1]
	return result
