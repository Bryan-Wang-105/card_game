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
	
	# Spawn enemy
	enemy_manager.spawn_enemy()
	
	# Populate the battlefield
	battlefield.populate_initial_enemies()

func end_turn():
	# battle logic
	var enemyRow = battlefield.enemyRow
	var playerRow = battlefield.playerRow
	var index = 0
	
	print("END TURN")
	print("ENEMY")
	print(enemyRow)
	print("PLAYER")
	print(playerRow)
	for slot in playerRow:
		# If card is in our row at this slot
		if slot:
			print(slot)
			# If there is an opposing enemy
			if enemyRow[index]:
				print("ENEMY OPPOSING CARD")
				var opp_card = enemyRow[index]
				
				battlefield.attack_enemy_card(index, slot.attack_curr)
				print(opp_card.health_base)

			# Free hit enemy
			else:
				print(enemy_manager.curr_enemy_health)
				enemy_manager.take_dmg(slot.attack_curr)
				print("DELT DMG " + str(slot.attack_curr) + " TO ENEMY")
				print(enemy_manager.curr_enemy_health)
				room_manager.update_enemy_health_ui()
		
		index += 1
	
	# If enemy is alive, change turn
	if enemy_manager.is_alive():
		enemy_turn()
	else:
		win_battle()


func enemy_turn():
	print("ENEMY STILL ALIVE")
	# battle logic
	var enemyRow = battlefield.enemyRow
	var playerRow = battlefield.playerRow
	var index = 0
	battlefield.toggle_end_turn()
	print("ENEMY ATTACKING")
	print("Waiting 1.5 seconds...")
	await get_tree().create_timer(1.5).timeout
	print("1.5 seconds passed")
	
	print("ENEMY")
	print(enemyRow)
	print("PLAYER")
	print(playerRow)
	for slot in enemyRow:
		# If card is in our row at this slot (object)
		if slot:
			print(slot)
			# If there is a player card opposing
			if playerRow[index]:
				print("PLAYER CARD OPPOSING")
				var player_card = playerRow[index]
				
				battlefield.attack_player_card(index, slot.attack_curr)
				print(player_card.health_base)

			# Free hit player
			else:
				player_manager.take_damage(slot.attack_curr)
				print("DELT DMG " + str(slot.attack_curr) + " TO PLAYER")
				print(player_manager.health)
				#player_manager.update_enemy_health_ui()
		
		index += 1
	
	# If enemy is alive, change turn
	if player_manager.is_alive():
		battlefield.next_wave()
		reset_player_turn()
	else:
		print("LOST BATTLE")
		pass
		#lose_battle()

func win_battle():
	in_battle = false
	print("BATTLE WON")
	print("Waiting 1.5 seconds...")
	await get_tree().create_timer(1.5).timeout
	print("1.5 seconds passed")
	battlefield.clean_board()
	player_manager.clean_GUI()
	player_manager.grab_loot(enemy_manager.loot)
	room_manager.cleanup_battlefield()
	deck_manager.reset_deck()

func reset_player_turn():
	player_manager.your_turn_setup()
	battlefield.toggle_end_turn()
