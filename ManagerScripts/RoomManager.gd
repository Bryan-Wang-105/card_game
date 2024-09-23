extends Node3D

enum gameState { OPEN_MAP, BATTLING }
var state: gameState = gameState.OPEN_MAP

@onready var player_manager: Node = $"../PlayerManager"
@onready var GUI: Node = $"../PlayerManager/GUI"
@onready var battle_manager: Node = $"../BattleManager"
@onready var enemy_manager: Node = $"../EnemyManager"
@onready var draw_pile: StaticBody3D = $drawPile
@onready var battlefield: StaticBody3D = $Battlefield
@onready var map: StaticBody3D = $Map
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var enemy_hp: MeshInstance3D = $Enemy/enemy_hp

var available_nodes = []
var level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if state == 0:
		make_disappear(draw_pile)
		make_disappear(battlefield)
		enemy_hp.visible = false
	
	available_nodes.append(1)
	
	level = 1
	pass

func clicked_event(num):
	if num == 0:
		print("No real event clicked")
	elif num in available_nodes:
		var event_collider = map.get_child(num)
		
		if "battle" in event_collider.get_child(0).get_groups():
			map.clear_map()
			call_battle_manager_start()

	else:
		print("NOT AVAILABLE YET")
		

func call_battle_manager_start():
	make_reappear(draw_pile)
	make_reappear(battlefield)
	GUI.show_labels()
	animation_player.play("spawn_field")
	battle_manager.start_battle()
	
	enemy_hp.visible = true
	update_enemy_health_ui()

func update_enemy_health_ui():
	if enemy_manager.curr_enemy_health <= 0:
		enemy_hp.mesh.text = "~ DEFEATED ~"
	else:
		enemy_hp.mesh.text = str(enemy_manager.curr_enemy_health) + " HP"

func make_disappear(item):
	item.set_collision_layer(0)
	item.set_collision_mask(0)
	item.visible = false

func make_reappear(item):
	# This is a bit mask for layer 1 and 2 (allegedly)
	item.collision_layer = 3
	item.set_collision_mask(2)
	item.visible = true
