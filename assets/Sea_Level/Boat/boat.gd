extends RigidBody3D
class_name Boat

var player : Player
var tv : TV

# --- New Paddle Variables ---
var paddle_l : Node3D
var paddle_r : Node3D
# ---------------------------

@export var paddle_force := 100.0
@export var boat_width := 1.5
@export var paddle_offset_y := 0.5    # Height relative to boat center
@export var paddle_offset_z := 0.2    # Move forward/backward relative to center
@export var linear_drag := 1.2
@export var angular_drag := 2.5
@export var duck_static_scene: PackedScene
@export var duck_inventory_id : int

@export var duck_collectors: Array[Marker3D]
var spawned_ducks : int

func on_level_load() -> void:
	player = GameManager.player_ref
	
	player.reparent(self, false)
	player.transform = $PlayerSocket.transform
	player.update_look_at_distance(-10)

	
	tv = GameManager.tv_ref
	tv.transform = $TVSocket.transform
	tv.reparent(self, false)

	
	# --- Paddle Setup ---
	# Assuming paddles are stored in GameManager or are children of this node
	paddle_l = $Paddle_L
	paddle_r = $Paddle_R
	

	player._isOnBoat = true # Tell the player to stop moving themselves
	
	linear_damp = linear_drag
	angular_damp = angular_drag

func _physics_process(delta: float) -> void:
	# Get the boat's local forward and right directions
	var forward_dir = global_transform.basis.z
	var right_dir = global_transform.basis.x
	
	# Calculate the offset positions relative to the boat's center
	# We use global_basis so the 'sides' rotate with the boat
	var left_side_offset = -right_dir * boat_width
	var right_side_offset = right_dir * boat_width
	
	var multiplier = 1.0
	if Input.is_action_pressed("down"):
		multiplier = -0.5 # Paddling backward is usually weaker

	# 1. Paddle Left Input (Turns boat RIGHT)
	if Input.is_action_just_released("left"):
		# apply_force takes (force_vector, offset_from_center)
		apply_force(forward_dir * paddle_force * multiplier, left_side_offset)
		# Visual Kick
		paddle_l.rotation.x += deg_to_rad(20) 

	# 2. Paddle Right Input (Turns boat LEFT)
	if Input.is_action_just_released("right"):
		apply_force(forward_dir * paddle_force * multiplier, right_side_offset)
		# Visual Kick
		paddle_r.rotation.x += deg_to_rad(20)

	# --- Visual Paddle Reset ---
	# Smoothly returns paddles to neutral rotation
	paddle_l.rotation.x = lerp_angle(paddle_l.rotation.x, 0, delta * 2.0)
	paddle_r.rotation.x = lerp_angle(paddle_r.rotation.x, 0, delta * 2.0)

func spawn_ducks(count : int):
	if spawned_ducks < count:
		for marker in duck_collectors:
			if spawned_ducks >= count:
				return
			if marker.get_child_count() <= 0:
				var duck = duck_static_scene.instantiate()
				duck.position = marker.position
				marker.add_child(duck)
				spawned_ducks += 1

	

func	 _process(delta: float) -> void:
	var current : int = 0
	if GameManager.player_ref and GameManager.player_ref.inventoryItemsDict.has(duck_inventory_id):
		current = GameManager.player_ref.inventoryItemsDict.get(duck_inventory_id)
		spawn_ducks(current)
		
