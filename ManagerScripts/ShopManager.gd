extends StaticBody3D

@onready var room_manager: Node3D = $".."
@onready var cam_manager: Node3D = $"../../CamNode/Head/Camera3D"

# when calling get_child, needs to offset by non-collider nodes
@onready var colliderOffset = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Clicked on a shop collider
func clickShop(x):
	print("SHOP CLICK INDEX IS %d" % x)
	if get_child(x + colliderOffset).name == "ShopCollider":
		print("CLICKED SHOP")
		cam_manager.view_shop()
	elif get_child(x + colliderOffset).name == "ContinueCollider":
		print("CLICKED CONTINUE - NOW LEAVING")
		room_manager.cleanup_shop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
