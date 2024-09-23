extends Node3D


#const CARD = preload("res://cards/card.tscn")
const CARD = preload("res://CARD.tscn")
var HAND_WIDTH = .35
@export var curve: Curve
@export var offsetCurve: Curve
@export var heightCurve: Curve
@export var angleCurve: Curve
@onready var camera = $"../../"
@onready var animation_player = $"../../../../AnimationPlayer"
@onready var deck_manager = $"../../../../../DeckManager"

var hide = 0
var timer
var num = 1          #?
var cur_index = 0    #?
var selected_card = null
var held_card = null

func cleanup_hand():
	selected_card = null
	for child in get_children():
		child.queue_free()

func add_x_cards(x) -> void:
	if !hide:
		for _x in x:
			var top_card = deck_manager.get_top_card().new()
			deck_manager.next_card()
			var card = CARD.instantiate()
			
			add_child(card) 
			
			var name_mesh = card.get_child(0)
			var label = card.get_child(3)
			var sprite3d = card.get_child(5)
			var atk_mesh = card.get_child(1)
			var hlth_mesh = card.get_child(2)
			
			name_mesh.mesh = name_mesh.mesh.duplicate()
			atk_mesh.mesh = atk_mesh.mesh.duplicate()
			hlth_mesh.mesh = hlth_mesh.mesh.duplicate()
			
			label.text = top_card.card_description
			sprite3d.texture = load(top_card.art_path)
			
			name_mesh = name_mesh.mesh as TextMesh
			atk_mesh = atk_mesh.mesh as TextMesh
			hlth_mesh = hlth_mesh.mesh as TextMesh
			
			if name_mesh:
				name_mesh.text = top_card.card_name
				atk_mesh.text = str(top_card.attack)
				hlth_mesh.text = str(top_card.health)
			
			card.cardObj = top_card
			card.hand_pos = len(get_children()) - 1
			
			num += 1

func fan_cards() -> void:
	var offset = .007
	var count = 0
	
	for card in get_children():
		var hand_ratio = .5
		
		if get_child_count() > 1:
			hand_ratio = float(card.get_index()) / float(get_child_count() - 1)
		
		card.position.z = offset*count
		count += 1
		card.position.x = curve.sample(hand_ratio) * HAND_WIDTH
		print(curve.sample(hand_ratio))
		#print(offsetCurve.sample(len(get_children())/7))
		#card.position.x = curve.sample(hand_ratio) * (offsetCurve.sample(len(get_children())/7))
		card.position.y = heightCurve.sample(hand_ratio) * .01
		
		card.rotation.y = angleCurve.sample(hand_ratio) * .3
		card.rotation.z = angleCurve.sample(hand_ratio) * .3
		
		card.original_rotation = card.rotation
		card.original_position = card.position

func hide_hand() -> void:
	if !hide:
		print("play")
		animation_player.play("hide_hand")
		hide = 1

	else:
		print("rewind")
		visible = true
		animation_player.play_backwards("hide_hand")
		hide = 0

func select(x):
	var i = 0
	
	for child in get_children():
		if i != x:
			child.visible = false
			child.set_collision_layer(0)
			child.set_collision_mask(0)
		else:
			child.set_state(2)
		i += 1

func unselect(x):
	var i = 0
	
	for child in get_children():
		if i != x:
			child.visible = true
			child.set_collision_layer(2)
			child.set_collision_mask(1)
		else:
			child.set_state(1)
		i += 1

func finish_placing():
	var i = 0
	fan_cards()
	
	for child in get_children():
		child.hand_pos = i
		child.visible = true
		child.set_collision_layer(2)
		child.set_collision_mask(1)
		i += 1
