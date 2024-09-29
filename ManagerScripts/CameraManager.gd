extends Camera3D

@onready var player_manager: Node = $'../../../PlayerManager'
@onready var table: Node = $'../../Table'
@onready var hand: Node = $'Root/Hand'
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var battlefield: StaticBody3D = $'../../../RoomManager/Battlefield'
@onready var room_manager: Node3D = $'../../../RoomManager'
@onready var battle_manager: Node = $'../../../BattleManager'

# Sensitivity of the mouse movement
@export var look_sensitivity: float = 0.2
@export var zoom_sensitivity: float = 4.0

# Field of view (FOV) limits for zoom
@export var min_fov: float = 30.0
@export var max_fov: float = 90.0

# Invert the Y axis if needed
@export var invert_y: bool = false

# Current rotation angles
var rotation_x: float = 0.0
var rotation_y: float = 0.0

# Camera pos/rot
var cam_indx = 0
var pos = []
var rot = []
var anim = []
var was_vis

# raycast vars
var mouse_pos
var ray_length
var from
var to
var space
var query
var raycast_result
var ray_query

# Current card
var interactable
var card_hovered
var prev_hovered = null

func _ready():
	# Hide the mouse cursor and capture it for camera look-around
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	pos.append(position)
	rot.append(Vector3(-.523,0,0))
	anim.append("POV_0_1")
	
	pos.append(position)
	rot.append(rotation)
	anim.append("POV_1_2")
		
	pos.append(table.position)
	rot.append(Vector3(-1.571,0,0))

func _process(delta: float) -> void:
		mouse_pos = get_viewport().get_mouse_position()
		ray_length = 3
		from = project_ray_origin(mouse_pos)
		to = from + project_ray_normal(mouse_pos) * ray_length
		space = get_world_3d().direct_space_state
		ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.collision_mask = 2
		ray_query.from = from
		ray_query.to = to
		raycast_result = space.intersect_ray(ray_query)

# CASE: Card Selected, mouse moved to null, card unselected, mouse move to null doesn't unhover
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Hovering something
		if raycast_result:
			# Hovering a card in hand
			if raycast_result.get("collider").is_in_group("cardInHand"):
				card_hovered = raycast_result.get("collider")
				
				# Hovering card in hand AND there is NOT a card currently selected
				if !hand.selected_card and card_hovered.state != 4:
					card_hovered.set_state(1)
					hand.selected_card = card_hovered
					prev_hovered = card_hovered
				# Hovering card in hand and there IS currently a card selected but it's not previously selected
				elif hand.selected_card and prev_hovered != card_hovered and prev_hovered and prev_hovered.is_in_group("cardInHand"):
					prev_hovered.set_state(0)
					card_hovered.set_state(1)
					hand.selected_card = card_hovered
					prev_hovered = card_hovered
				# Hovering and its SAME selected card
				else:
					prev_hovered = card_hovered
			# Hovering another interactable
			else:
				interactable = raycast_result.get("collider")
				# Is a card selected?
				if hand.selected_card:
					# Is card hovered?
					if hand.selected_card.state == 1:
						hand.selected_card.set_state(0)
						hand.selected_card = null
					elif hand.selected_card.state == 2:
						pass
				prev_hovered = interactable
		# Raycast returning NULL
		else:
			# Is card selected?
			if hand.selected_card:
				# Is card hovered?
				if hand.selected_card.state == 1:
					hand.selected_card.set_state(0)
					hand.selected_card = null
				elif hand.selected_card.state == 2:
					pass
			prev_hovered = null
	
	if Input.is_action_just_pressed("click"):
		if raycast_result:
			if player_manager.player_turn:
				var raycast_obj = raycast_result.get("collider")
				print(raycast_obj)
				# Clicked Drawpile
				if raycast_obj.name == "drawPile":
					if !hand.selected_card:
						player_manager._draw_card()
				# Clicked Battlefield Slot
				elif raycast_obj.is_in_group("cardSlot"):
					var fieldSlot = raycast_result.shape
					print("CLICKED ON BATTLEFIELD NODE:" + str(raycast_result.shape))
					print(raycast_obj.get_children())
					# Card slot clicked and Card Selected for play
					if hand.selected_card and hand.selected_card.state == 2 and fieldSlot < 4 and player_manager.actions_left > 0:
						if battlefield.check_slot(fieldSlot):
							print(hand.selected_card)
							hand.selected_card.hand_pos = -1
							hand.selected_card.set_state(4)
							battlefield.place_card(hand.selected_card, fieldSlot)
							hand.selected_card = null
							hand.finish_placing()
							player_manager.decrease_action()
							player_manager.hand_count -= 1
							player_manager.update_hand_count()
						else:
							hand.unselect(hand.selected_card.hand_pos)
							hand.selected_card.set_state(0)
							hand.selected_card = null
						pass
					# END TURN clicked w/no cards and on your turn
					elif !hand.selected_card and raycast_obj.get_child(fieldSlot).name == "EndTurnCollider" and player_manager.player_turn:
						print("TURN ENDED")
						player_manager.player_turn = false
						battle_manager.end_turn()
						pass
				# Clicked card in Hand
				elif raycast_obj.is_in_group("cardInHand"):
					print("CLICKED CARD IN HAND " + str(raycast_obj.hand_pos))
					print("CURR CARD STATE: " + str(raycast_obj.state))
					if raycast_obj.state == 2:
						print("UNSELECTED")
						hand.selected_card = null
						hand.unselect(raycast_obj.hand_pos)
						print("NEW CARD STATE: " + str(raycast_obj.state))
					else:
						print("SELECTED")
						hand.selected_card = raycast_obj
						hand.select(raycast_obj.hand_pos)
						print("NEW CARD STATE: " + str(raycast_obj.state))
				# Clicked Map
				elif raycast_obj.is_in_group("map"):
					print("CLICKED MAP")
					var mapCollider = raycast_result.shape
					print(mapCollider)
					room_manager.clicked_event(raycast_result.shape)
		else:
			print("NULL CLICK")
	
	if Input.is_action_just_pressed("w") or Input.is_action_pressed("scroll_up"):
		_move_cam_up()
	elif Input.is_action_just_pressed("s") or Input.is_action_pressed("scroll_down"):
		_move_cam_down()
	elif Input.is_action_just_pressed("rt_clk"):
		print(prev_hovered)
		print(raycast_result.get("collider"))

func _update_camera_rotation(mouse_delta: Vector2) -> void:
	# Adjust rotation speed based on sensitivity
	rotation_y -= mouse_delta.x * look_sensitivity
	rotation_x -= mouse_delta.y * look_sensitivity * 1

	# Clamp the X rotation to avoid flipping over the top/bottom
	rotation_x = clamp(rotation_x, -90, 90)

	# Apply rotations: Yaw (rotation_y) affects the Y axis, Pitch (rotation_x) affects the X axis
	rotation_degrees = Vector3(rotation_x, rotation_y, 0)

func _zoom_in() -> void:
	# Decrease FOV to zoom in, clamping within the limits
	fov = clamp(fov - zoom_sensitivity, min_fov, max_fov)

func _zoom_out() -> void:
	# Increase FOV to zoom out, clamping within the limits
	fov = clamp(fov + zoom_sensitivity, min_fov, max_fov)

func _move_cam_up() -> void:
	print("MOVE UP")
	if cam_indx < len(pos) - 1:
		animation_player.play(anim[cam_indx])
		cam_indx += 1

func _move_cam_down() -> void:
	print("MOVE DOWN")
	if cam_indx > 0:
		animation_player.play_backwards(anim[cam_indx-1])
		cam_indx -= 1
