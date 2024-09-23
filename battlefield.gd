extends StaticBody3D

@onready var camera = $'../../CamNode/Head/Camera3D'
@onready var hand = $'../../CamNode/Head/Camera3D/Root/Hand'
@onready var player_manager = $'../../PlayerManager'

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
	playerRow[location] = card
	var card_slot = get_child(location)
	card.get_parent().remove_child(card)
	card_slot.add_child(card)
	card_slot.remove_from_group("cardInHand")
	card_slot.add_to_group("cardOnBoard")
	
	card.global_transform = get_child(location).global_transform

func toggle_end_turn():
	get_child(8).disabled = !player_manager.player_turn
	get_child(8).visible = player_manager.player_turn
	get_child(9).visible = !player_manager.player_turn

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
