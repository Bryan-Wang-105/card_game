extends Control

@onready var hand_count: Label = $handCount
@onready var actions_left: Label = $actionCount
@onready var player: Node = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("b")
	hand_count.text = "In Hand: " + str(player.hand_count)
	actions_left.text = "Remaining Actions: " + str(player.actions_left)
	hand_count.visible = false
	actions_left.visible = false

func show_labels():
	hand_count.visible = true
	actions_left.visible = true

func update_hand_count(x) -> void:
	hand_count.text = "In Hand: " + x

func update_action_count(x) -> void:
	actions_left.text = "Remaining Actions: " + x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
