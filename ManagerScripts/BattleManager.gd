extends Node

@onready var player_manager: Node = $"../PlayerManager"
@onready var camera_3d: Camera3D = $"../CamNode/Head/Camera3D"
@onready var hand: Node3D = $"../CamNode/Head/Camera3D/Root/Hand"
@onready var deck_manager: Node = $"../DeckManager"
@onready var room_manager: Node3D = $"../RoomManager"
@onready var enemy_manager: Node = $"../EnemyManager"
@onready var battlefield: Node3D = $"../RoomManager/Battlefield"

var enemy_obj
var in_battle = false

func start_battle():
	print("STARTING BATTLE NOW")
	in_battle = true
	# Shuffle player hand
	deck_manager.shuffle()
	
	# spawn enemy
	enemy_manager.spawn_enemy()

func end_turn():
	# battle logic
	var enemyRow = battlefield.enemyRow
	var playerRow = battlefield.playerRow
	var index = 0
	
	print("END TURN")
	for slot in playerRow:
		# If card is in our row at this slot
		if slot:
			print(slot)
			# If there is an opposing enemy
			if enemyRow[index]:
				pass
			# Free hit enemy
			else:
				print(enemy_manager.curr_enemy_health)
				enemy_manager.take_dmg(slot.cardObj.attack)
				print("DELT DMG " + str(slot.cardObj.attack) + " TO ENEMY")
				print(enemy_manager.curr_enemy_health)
				room_manager.update_enemy_health_ui()
	
	# If enemy is alive, change turn
	if enemy_manager.is_alive():
		enemy_turn()
	else:
		win_battle()

func enemy_turn():
	print("ENEMY STILL ALIVE")
	battlefield.toggle_end_turn()
	print("Waiting 3 seconds...")
	await get_tree().create_timer(3.0).timeout
	print("3 seconds passed")
	print("ENEMY ATTACKS AND DOES NOTHING")
	print("END ENEMY TURN")
	print("PLAYER TURN NOW")
	reset_player_turn()
	pass

func win_battle():
	in_battle = false
	print("BATTLE WON")
	print("Waiting 1.5 seconds...")
	await get_tree().create_timer(1.5).timeout
	print("1.5 seconds passed")
	battlefield.clean_board()
	player_manager.your_turn_setup()
	room_manager.cleanup_battlefield()

func reset_player_turn():
	player_manager.your_turn_setup()
	battlefield.toggle_end_turn()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
