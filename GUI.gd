extends Control

@onready var hand_count: Label = $handCount
@onready var actions_left: Label = $actionCount
@onready var player_manager: Node = $".."
@onready var health: Label = $health
@onready var money: Label = $money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("b")
	health.text = "HEALTH: " + str(player_manager.health)  + " HP"
	actions_left.text = "ACTIONS LEFT THIS TURN: " + str(player_manager.actions_left)
	hand_count.text = "CARDS IN HAND: " + str(player_manager.hand_count)
	money.text = "MONEY: $" + str(player_manager.money)
	hand_count.visible = false
	actions_left.visible = false
	health.visible = false
	money.visible = false

func toggle_gui(inBattle):
	hand_count.visible = inBattle
	actions_left.visible = inBattle
	health.visible = inBattle
	money.visible = inBattle

func update_hand_count():
	hand_count.text = "CARDS IN HAND: " + str(player_manager.hand_count)

func update_action_count():
	actions_left.text = "ACTIONS LEFT THIS TURN: " + str(player_manager.actions_left)
	
func update_health():
	health.text = "HEALTH: " + str(player_manager.health) + " HP"

func update_money():
	money.text = "MONEY: $" + str(player_manager.money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
