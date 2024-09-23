extends Node

@onready var player_manager: Node = $"../PlayerManager"
@onready var camera_3d: Camera3D = $"../CamNode/Head/Camera3D"
@onready var hand: Node3D = $"../CamNode/Head/Camera3D/Root/Hand"
@onready var deck_manager: Node = $"../DeckManager"
@onready var room_manager: Node3D = $"../RoomManager"
@onready var enemy_manager: Node = $"../EnemyManager"
@onready var battlefield: Node3D = $"../RoomManager/Battlefield"

var enemy_obj
var turn

func start_battle():
	print("STARTING BATTLE NOW")
	# Shuffle player hand
	deck_manager.shuffle()
	
	# spawn enemy
	enemy_manager.spawn_enemy()

func enemy_turn():
	battlefield.toggle_end_turn()
	print("Waiting 3 seconds...")
	await get_tree().create_timer(3.0).timeout
	print("3 seconds passed")
	print("ENEMY ATTACKS AND DOES NOTHING")
	print("END ENEMY TURN")
	print("PLAYER TURN NOW")
	reset_player_turn()
	pass

func reset_player_turn():
	player_manager.your_turn_setup()
	battlefield.toggle_end_turn()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
