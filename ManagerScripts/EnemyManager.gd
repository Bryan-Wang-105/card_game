extends Node

@onready var battle_manager: Node = $"../BattleManager"
@onready var room_manager: Node = $"../RoomManager"
@onready var player_manager: Node = $"../PlayerManager"

var card_library = "res://cards/"
var curr_enemy_deck = []
var curr_enemy_health 
var top_card_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_enemy():
	# Create enemy deck
	spawn_enemy_deck()
	
	# Create and attach enemy health
	spawn_enemy_health()


func spawn_enemy_deck():
	var card_list = get_all_files_in_directory(card_library)
	print(card_list)
	if room_manager.level == 1:
		for i in range(4):
			var enemy_card_to_add = card_list[randi_range(0, len(card_list)-1)]
			curr_enemy_deck.append(load(enemy_card_to_add).new())
		top_card_index = 3
	else:
		curr_enemy_deck = []

func spawn_enemy_health():
	if room_manager.level == 1:
		curr_enemy_health = 8
	else:
		curr_enemy_health = 3

func get_next_in_deck():
	if top_card_index >= 0:
		top_card_index -= 1
		return curr_enemy_deck[top_card_index + 1]

func take_dmg(x):
	curr_enemy_health -= x

func is_alive():
	return curr_enemy_health > 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_all_files_in_directory(path: String) -> Array:
	var files = []
	
	# Open the directory at the specified path
	var dir = DirAccess.open(path)
	
	if dir:
		# Start reading the directory
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		while file_name != "":
			# Ignore '.' and '..' which represent the current and parent directories
			if not dir.current_is_dir() and ".tmp" not in file_name:
				files.append(card_library + file_name)
				
			file_name = dir.get_next()
		
		dir.list_dir_end()  # Close the directory after reading
	else:
		print("Failed to open directory: %s" % path)
	
	return files
