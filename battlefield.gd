extends StaticBody3D

@onready var camera = $'../../CamNode/Head/Camera3D'
@onready var hand = $'../../CamNode/Head/Camera3D/Root/Hand'
@onready var player_manager = $'../../PlayerManager'
@onready var enemy_manager = $'../../EnemyManager'
@onready var room_manager = $'../../RoomManager'

const CARD = preload("res://CARD.tscn")
var enemyRow
var playerRow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("POSITIONS")
	print(position)
	enemyRow = [null, null, null, null]
	playerRow = [null, null, null, null]
	pass # Replace with function body.

func check_slot(location):
	return playerRow[location] == null

func place_card(card, location):
	print(card, location)
	playerRow[location] = card.cardObj
	var card_slot = get_child(location)
	card.get_parent().remove_child(card)
	card_slot.add_child(card)
	card_slot.remove_from_group("cardInHand")
	card_slot.add_to_group("cardOnBoard")
	
	card.global_transform = get_child(location).global_transform
	card.global_position.y += .005

func toggle_end_turn():
	get_child(8).disabled = !player_manager.player_turn
	get_child(8).visible = player_manager.player_turn
	get_child(9).visible = !player_manager.player_turn

func clean_board():
	enemyRow = [null, null, null, null]

	for i in range(4):
		if playerRow[i]:
			playerRow[i] = null
			get_child(i).get_child(1).queue_free()

func populate_enemies():
	if room_manager.level == 1:
		for i in range(2):
			var indx = randi_range(0,3)
			while enemyRow[indx]:
				indx = randi_range(0,3)
			var enemy_card = enemy_manager.get_next_in_deck()
			print(enemy_card)
			enemyRow[indx] = enemy_card
			enemy_card = create_3D_card(enemy_card)
			set_card_on_slot(indx + 4, enemy_card)
	else:
		pass

func set_card_on_slot(indx, enemy_card):
	var slot = get_child(indx)
	slot.add_child(enemy_card)
	var new_card = slot.get_child(1)
	new_card.rotation_degrees.x = 0
	new_card.position.y = .005
	new_card.collision_layer = 0
	

func create_3D_card(card_obj):
	var card = CARD.instantiate()
			
	var name_mesh = card.get_child(0)
	var label = card.get_child(3)
	var sprite3d = card.get_child(5)
	var atk_mesh = card.get_child(1)
	var hlth_mesh = card.get_child(2)
			
	name_mesh.mesh = name_mesh.mesh.duplicate()
	atk_mesh.mesh = atk_mesh.mesh.duplicate()
	hlth_mesh.mesh = hlth_mesh.mesh.duplicate()
			
	label.text = card_obj.card_description
	sprite3d.texture = load(card_obj.art_path)
			
	name_mesh = name_mesh.mesh as TextMesh
	atk_mesh = atk_mesh.mesh as TextMesh
	hlth_mesh = hlth_mesh.mesh as TextMesh
			
	if name_mesh:
		name_mesh.text = card_obj.card_name
		atk_mesh.text = str(card_obj.attack_base)
		hlth_mesh.text = str(card_obj.health_base)
	
	card.rotation_degrees.x = 90
	
	return card

func update_3D_card(card_to_update, new_hp, new_atk):
	if new_hp <= 0:
		card_to_update.queue_free()
	else:
		var atk_mesh = card_to_update.get_child(1)
		var hlth_mesh = card_to_update.get_child(2)

		atk_mesh.mesh = atk_mesh.mesh.duplicate()
		hlth_mesh.mesh = hlth_mesh.mesh.duplicate()

		atk_mesh = atk_mesh.mesh as TextMesh
		hlth_mesh = hlth_mesh.mesh as TextMesh

		atk_mesh.text = str(new_atk)
		hlth_mesh.text = str(new_hp)

func attack_enemy_card(index, atk_amt):
	var curr_enemy = enemyRow[index]
	curr_enemy.health_curr -= atk_amt
	
	var card_to_update = get_child(index+4).get_child(1)
	
	update_3D_card(card_to_update, curr_enemy.health_curr, curr_enemy.attack_curr)
	if curr_enemy.health_curr <= 0:
		print("KILLED ENEMY CARD")
		enemyRow[index] = null

func attack_player_card(index, atk_amt):
	var player_card = playerRow[index]
	player_card.health_curr -= atk_amt
	
	var card_to_update = get_child(index).get_child(1)
	
	update_3D_card(card_to_update, player_card.health_curr, player_card.attack_curr)
	if player_card.health_curr <= 0:
		print("KILLED PLAYER CARD")
		playerRow[index] = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
