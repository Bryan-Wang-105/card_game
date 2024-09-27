extends StaticBody3D

var available_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	available_nodes = [1]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
