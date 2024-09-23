extends Node

@onready var player: Node = $Player
@onready var gui: Control = $GUI
@onready var hand: Node3D = $"../CamNode/Head/Camera3D/Root/Hand"

@export var actions_left = 5
@export var hand_count = 0
@export var actions_left_base = 5
@export var health = 10
@export var player_turn = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shift") and hand_count > 0:
		hand.hide_hand()
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()

func has_actions_left() -> bool:
	return actions_left > 0

func _draw_card() -> void:
	if !hand.hide and has_actions_left():
		hand_count += 1
		gui.update_hand_count(str(hand_count))
		
		decrease_action()
		
		hand.add_x_cards(1)
		hand.fan_cards()

func update_hand_count():
	gui.update_hand_count(str(hand_count))

func decrease_action():
	actions_left -= 1
	gui.update_action_count(str(actions_left))

func your_turn_setup():
	actions_left = actions_left_base
	player_turn = true
	gui.update_action_count(str(actions_left))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
