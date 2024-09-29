extends StaticBody3D

@onready var starting_point: Node3D = $"Starting point"

var path_to_combat = "res://3D_art/CombatEvent/CombatEvent.tscn"
var path_to_shop = "res://3D_art/ShopEvent/ShopEvent.tscn"
var toSpawnCombat = load(path_to_combat)
var toSpawnShop = load(path_to_shop)
var available_nodes = []
var avail_nodes_dict = {}

var layers := 5
var nodes_per_layer := [5, 3, 4, 3, 1]  # Number of nodes per layer
var nodes := []  # Array to store nodes
var paths := []  # Array to store paths (connections between nodes)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_blueprint()
	generate_nodes_and_paths()

func create_blueprint():
	for i in range(layers-1):
		nodes_per_layer[i] = randi_range(2, 5)

# Generates the nodes and paths as arrays
func generate_nodes_and_paths():
	var percent
	var scene_instance
	var start_node = get_node("Starting point")
	var node_pos
	
	for layer_index in range(layers):
		var current_layer_nodes := []
		var horizontal_offset = []
		node_pos = start_node.get_child(layer_index)
		horizontal_offset = generate_random_points(nodes_per_layer[layer_index])
		horizontal_offset.sort()
		# Generate nodes for each layer (store their unique IDs)
		for node_index in range(nodes_per_layer[layer_index]):
			percent = randi_range(0,10)
			
			if percent >= 0 and percent < 4 and layer_index != 0 and layer_index != layers-1:
				scene_instance = toSpawnShop.instantiate()
			else:
				scene_instance = toSpawnCombat.instantiate()

			# Set the position of the new instance to the position of the specified node
			scene_instance.position = node_pos.position
			scene_instance.position.y = node_pos.position.y + .08
			if len(horizontal_offset) > 1:
				scene_instance.position.x = node_pos.position.x + horizontal_offset[node_index]

			#current_layer_nodes.append("Layer %d / Node %d" % [layer_index, node_index])
			current_layer_nodes.append(scene_instance)
			
			# Add the instance to the current scene
			add_child(scene_instance)
			
		nodes.append(current_layer_nodes)

		# Connect the nodes from the previous layer to the current layer
		if layer_index > 0:
			connect_nodes_without_intersections(nodes[layer_index - 1], current_layer_nodes)
		

	draw_connecting_node_lines()

	print("Nodes: ", nodes)
	print("\n")
	print("Paths: ", paths)
	
	available_nodes = nodes[0]
	print("CAN GO HERE")
	print(available_nodes)
	
	# Could eventually use a dict for both paths and available node feature but too lazy
	for path in paths:
		if path[0] not in avail_nodes_dict:
			avail_nodes_dict[path[0]] = [path[1]]
		else:
			avail_nodes_dict[path[0]].append(path[1])
	
	print(avail_nodes_dict)

func draw_connecting_node_lines():
	for path in paths:
		# Create lines between each pair of nodes in the path
		var node_a = path[0]
		var node_b = path[1]
		create_line_between_nodes(node_a, node_b)

# Ensures nodes are connected without intersections
func connect_nodes_without_intersections(previous_layer: Array, current_layer: Array):	
	var previous_size = previous_layer.size()
	var current_size = current_layer.size()

	# Track connections for each node in the current layer
	var current_layer_connections = []
	for i in range(current_size):
		current_layer_connections.append(0)  # Initialize with no parents

	# First pass: Ensure each node in the previous layer has at least one connection
	for i in range(previous_size):
		# Map the node in the previous layer to an index range in the current layer
		var start_index = int(floor(float(i) * current_size / previous_size))
		var end_index = int(ceil(float(i + 1) * current_size / previous_size)) - 1
		
		# Ensure no overlapping connections, connect to nodes within the calculated range
		for j in range(start_index, end_index + 1):
			if j < current_size:
				paths.append([previous_layer[i], current_layer[j]])
				current_layer_connections[j] += 1
				break  # Ensure at least one connection

	# Second pass: Optionally add additional connections and ensure every node has at least one parent
	for i in range(previous_size):
		var start_index := int(floor(float(i) * current_size / previous_size))
		var end_index := int(ceil(float(i + 1) * current_size / previous_size)) - 1
		
		if i == previous_size - 1:
			# On second-to-last layer, connect all possible nodes to the final layer
			for j in range(start_index, end_index + 1):
				if j < current_size and !is_path_exists(previous_layer[i], current_layer[j]):
					paths.append([previous_layer[i], current_layer[j]])
					current_layer_connections[j] += 1
		else:
			# For other layers, add some optional connections with 50% chance, and ensure no crisscrossing
			if current_size > 1:
				for j in range(start_index + 1, end_index + 1):
					if j < current_size and !is_path_exists(previous_layer[i], current_layer[j]):
						# Randomly skip the connection if the current node already has a connection
						if randf() < 0.5:
							paths.append([previous_layer[i], current_layer[j]])
							current_layer_connections[j] += 1

	# Ensure every node in the current layer has at least one parent
	for j in range(current_size):
		if current_layer_connections[j] == 0:
			# If a node has no parent, force a connection from the previous layer
			var fallback_parent = randi() % previous_size  # Random fallback parent from previous layer
			paths.append([previous_layer[fallback_parent], current_layer[j]])
			current_layer_connections[j] += 1
	
	# If there is two layers with same sizes, throw in some connections
	if current_size == previous_size:
		var numNodesToMod = randi_range(0, current_size-1)
		var nodesToModIndex = []
		var count = 0
		var num
		
		while count < numNodesToMod:
			num = randi_range(0,current_size-1)
			if num in nodesToModIndex:
				if num == 0 or num == current_size - 1:
					pass
				elif nodesToModIndex.count(num) >= 2:
					pass
				else:
					nodesToModIndex.append(num)
					count += 1
			else:
				nodesToModIndex.append(num)
				count += 1
		
		print("SORTING HERE")
		nodesToModIndex.sort()
		print(nodesToModIndex)
		
		count = 0
		for nodeIndex in nodesToModIndex:
			if nodeIndex == 0:
				paths.append([previous_layer[0], current_layer[1]])
			elif nodeIndex == current_size - 1:
				paths.append([previous_layer[current_size - 1], current_layer[current_size - 2]])
			else:
				if nodeIndex - 1 in nodesToModIndex and nodeIndex + 1 in nodesToModIndex:
					pass
				elif nodeIndex - 1 in nodesToModIndex or nodeIndex in nodesToModIndex.slice(0,count):
					paths.append([previous_layer[nodeIndex], current_layer[nodeIndex + 1]])
				else:
					paths.append([previous_layer[nodeIndex], current_layer[nodeIndex - 1]])
			count += 1

# Checks if a path between two nodes already exists
func is_path_exists(node_a, node_b) -> bool:
	for path in paths:
		if path[0] == node_a and path[1] == node_b:
			return true
	return false

func get_available_nodes():
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

func restore_map(curr_node):
	var index = 0
	
	for child in get_children():
		if index == 0:
			pass
		else:
			child.visible = true
			child.disabled = false
		index += 1
	
	update_available_nodes(curr_node)

func update_available_nodes(x):
	if x in avail_nodes_dict:
		available_nodes = avail_nodes_dict[x]
	# At End
	else:
		available_nodes = []
	
func generate_random_points(num_points: int) -> Array:
	# Validate the input to ensure it doesn't exceed 5 points
	if num_points < 1 or num_points > 5:
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
	
# Function to create a line mesh between two nodes
func create_line_between_nodes(node_a: Node3D, node_b: Node3D) -> void:
	# Get positions of the two nodes
	var pos_a = node_a.global_position
	var pos_b = node_b.global_position

	# Calculate the distance between the nodes
	var distance = pos_a.distance_to(pos_b)

	# Calculate the midpoint
	var midpoint = (pos_a + pos_b) / 2
	midpoint.y = .021

	# Create the BoxMesh
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(0.015, 0.01, distance)  # Set the dimensions, z is the distance
	
	# Create a MeshInstance3D to hold the mesh
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = box_mesh

	# Create a black material
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0, 0, 0)  # Set color to black

	# Assign the material to the MeshInstance3D
	mesh_instance.material_override = material

	# Set the position to the midpoint
	mesh_instance.global_position = midpoint

	# Calculate the rotation around the Y axis
	var direction = (pos_b - pos_a).normalized()
	var rotation_y = direction.angle_to(Vector3.FORWARD)
	var dir
	if pos_a.x > pos_b.x:
		dir = 1
	else:
		dir = -1

	# Set the rotation of the mesh instance
	mesh_instance.rotation_degrees.y = rotation_y * rad_to_deg(1)  * dir # Convert to degrees
	
	# Add the MeshInstance3D to the current node
	add_child(mesh_instance)
	
	# Save its exact orientation
	var orientation = mesh_instance.global_transform
	
	# Remove its parent and give it new parent
	mesh_instance.get_parent().remove_child(mesh_instance)
	node_a.add_child(mesh_instance)
	
	# Restore it's orientation
	mesh_instance.global_transform = orientation
