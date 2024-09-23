extends Node

@onready var battle_manager: Node = $"../BattleManager"
@onready var room_manager: Node = $"../RoomManager"

var card_library = "res://cards/"
var curr_enemy_deck = []
var curr_enemy_health 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_enemy():
	# Create enemy deck
	spawn_enemy_deck()
	
	# Create and attach enemy health
	spawn_enemy_health()


func spawn_enemy_deck():
	curr_enemy_deck = []

func spawn_enemy_health():
	curr_enemy_health = 3

func take_dmg(x):
	curr_enemy_health -= x

func is_alive():
	return curr_enemy_health > 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# 
