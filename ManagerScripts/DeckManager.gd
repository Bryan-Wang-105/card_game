extends Node

@export var cards: Array[Resource]
var top_index

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(cards)
	shuffle()
	print(cards)
	top_index = len(cards) - 1
	pass # Replace with function body.

func shuffle():
	cards.shuffle()

func get_top_card():
	return cards[top_index]

func next_card():
	top_index -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
