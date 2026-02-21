extends RigidBody3D
class_name Boat

var player : Player
var tv : TV

@export var paddle_force := 100.0
@export var boat_width := 1.5      # Distance from center to the "paddle" point
@export var linear_drag := 1.2
@export var angular_drag := 2.5

func on_level_load() -> void:
	player = GameManager.player_ref
	
	player.reparent(self, false)
	player.transform = $PlayerSocket.transform

	
	tv = GameManager.tv_ref
	tv.transform = $TVSocket.transform
	tv.reparent(self, false)
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

	# 2. Paddle Right Input (Turns boat LEFT)
	if Input.is_action_just_released("right"):
		apply_force(forward_dir * paddle_force * multiplier, right_side_offset)
