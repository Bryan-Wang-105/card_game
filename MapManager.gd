extends StaticBody3D

@onready var starting_point: Node3D = $"Starting point"

var path_to_combat = "res://3D_art/CombatEvent/CombatEvent.tscn"
var path_to_shop = "res://3D_art/ShopEvent/ShopEvent.tscn"
var toSpawnCombat = load(path_to_combat)
var toSpawnShop = load(path_to_shop)
var available_nodes = []

var layers := 5
var nodes_per_layer := [5, 3, 4, 3, 1]  # Number of nodes per layer
var nodes := []  # Array to store nodes
var paths := []  # Array to store paths (connections between nodes)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#place_events()
	generate_nodes_and_paths()

func place_events():
	var scene_instance
	var start_node = get_node("Starting point")
	var node_pos
	
	for i in range(layers):
		node_pos = start_node.get_child(i)
		
		if i % 2 == 0:
			# Create an instance of the combat
			scene_instance = toSpawnCombat.instantiate()
		else:
			# Create an instance of the shop
			scene_instance = toSpawnShop.instantiate()

		print(node_pos)
		print(node_pos.position)
		# Set the position of the new instance to the position of the specified node
		scene_instance.position = node_pos.position
		scene_instance.position.y = node_pos.position.y + .15

		# Add the instance to the current scene
		add_child(scene_instance)


# Generates the nodes and paths as arrays
func generate_nodes_and_paths():
	var percent
	var scene_instance
	var start_node = get_node("Starting point")
	var node_pos
	
	print("A")
	for layer_index in range(layers):
		print(layer_index)
		var current_layer_nodes := []
		var horizontal_offset = []
		node_pos = start_node.get_child(layer_index)
		horizontal_offset = generate_random_points(nodes_per_layer[layer_index])
		print("B")
		# Generate nodes for each layer (store their unique IDs)
		for node_index in range(nodes_per_layer[layer_index]):
			percent = randi_range(0,1)
			if percent == 0:
				scene_instance = toSpawnCombat.instantiate()
			else:
				scene_instance = toSpawnShop.instantiate()

			# Set the position of the new instance to the position of the specified node
			scene_instance.position = node_pos.position
			scene_instance.position.y = node_pos.position.y + .15

			if len(horizontal_offset) > 1:
				scene_instance.position.x = node_pos.position.x + horizontal_offset[node_index]

			current_layer_nodes.append("Layer %d / Node %d" % [layer_index, node_index])

			# Add the instance to the current scene
			add_child(scene_instance)
			
			nodes.append(current_layer_nodes)

			# Connect the nodes from the previous layer to the current layer
			if layer_index > 0:
				connect_nodes_without_intersections(nodes[layer_index - 1], current_layer_nodes)

	print("Nodes: ", nodes)
	print("Paths: ", paths)
	
	available_nodes = nodes[0]

# Ensures nodes are connected without intersections
func connect_nodes_without_intersections(previous_layer: Array, current_layer: Array):
	var previous_size = previous_layer.size()
	var current_size = current_layer.size()

	for i in range(previous_size):
		# Map the node in the previous layer to an index range in the current layer
		var start_index = int(floor(float(i) * current_size / previous_size))
		var end_index = int(ceil(float(i + 1) * current_size / previous_size)) - 1
		
		# Ensure no overlapping connections, connect to nodes within the calculated range
		for j in range(start_index, end_index + 1):
			if j < current_size:
				paths.append([previous_layer[i], current_layer[j]])
				break  # Ensure at least one connection

	# Optionally, add additional connections without crossing existing ones
	for i in range(previous_size):
		var start_index := int(floor(float(i) * current_size / previous_size))
		var end_index := int(ceil(float(i + 1) * current_size / previous_size)) - 1
		
		if current_size > 1:
			for j in range(start_index + 1, end_index + 1):
				if j < current_size and !is_path_exists(previous_layer[i], current_layer[j]):
					paths.append([previous_layer[i], current_layer[j]])

# Checks if a path between two nodes already exists
func is_path_exists(node_a: String, node_b: String) -> bool:
	for path in paths:
		if path[0] == node_a and path[1] == node_b:
			return true
	return false

func get_available_nodes():
	print("AVAILABLE NODES")
	print(available_nodes)
	return available_nodes

func clear_map():
	var index = 0
	
	for child in get_children():
		if index == 0:
			pass
		else:
			child.visible = false
			child.disabled = true
		index += 1

func restore_map():
	var index = 0
	
	for child in get_children():
		if index == 0:
			pass
		else:
			child.visible = true
			child.disabled = false
		index += 1
	
	update_available_nodes()

func update_available_nodes():
	available_nodes[0] += 1
	
	
func generate_random_points(num_points: int) -> Array:
	# Validate the input to ensure it doesn't exceed 5 points
	if num_points < 1 or num_points > 5:
		print("Number of points must be between 1 and 5.")
		return []

	var points = []
	var lower_bound = -1
	var upper_bound = 1
	var boundary = 0.3

	# Generate unique random points within the specified range and minimum distance
	while points.size() < num_points:
		var random_point = randf_range(lower_bound + boundary, upper_bound - boundary)

		# Check if the point respects the minimum distance
		var is_valid_point = true
		for point in points:
			if abs(random_point - point) < 0.2:
				is_valid_point = false
				break

		# If valid, add the point to the list
		if is_valid_point:
			points.append(random_point)

	return points
	

