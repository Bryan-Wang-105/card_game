extends StaticBody3D

@export var hand_pos: int

enum CardState { NEUTRAL, HOVERED, SELECTED, PLACED }

var state: CardState = CardState.NEUTRAL
var cardObj 
var original_position
var original_rotation
var original_transform

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_transform.origin
	original_rotation = rotation_degrees
	
	hand_pos = 0

# Set State Func
func set_state(new_state: CardState):
	state = new_state
	match state:
		CardState.NEUTRAL:
			return_to_neutral()
		CardState.HOVERED:
			hover_card()
		CardState.SELECTED:
			select_card()
		CardState.PLACED:
			pass

func return_to_neutral():
	position = original_position
	rotation = original_rotation

func hover_card():
	position.y = original_position.y + .1
	position.z = original_position.z + .1
	
func select_card():
	pass
