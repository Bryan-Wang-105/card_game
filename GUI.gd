extends Control

@onready var hand_count: Label = $handCount
@onready var actions_left: Label = $actionCount
@onready var player_manager: Node = $".."
@onready var health: Label = $health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("b")
	hand_count.text = "In Hand: " + str(player_manager.hand_count)
	actions_left.text = "Remaining Actions: " + str(player_manager.actions_left)
	health.text = "Health: " + str(player_manager.health)
	hand_count.visible = false
	actions_left.visible = false
	health.visible = false

func toggle_gui(inBattle):
	hand_count.visible = inBattle
	actions_left.visible = inBattle
	health.visible = inBattle

func update_hand_count():
	hand_count.text = "In Hand: " + str(player_manager.hand_count)

func update_action_count():
	actions_left.text = "Remaining Actions: " + str(player_manager.actions_left)
	
func update_health():
	health.text = "Health: " + str(player_manager.health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
