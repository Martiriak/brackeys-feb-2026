extends Node3D

@export var radius: float = 5.0      # How far from the center
@export var speed: float = 2.0       # How fast it moves
@export var height: float = 5.0      # Fixed Y position

var time_passed: float = 0.0

func _process(delta: float) -> void:
	# Keep track of time to calculate the angle
	time_passed += delta * speed
	
	# Calculate the new X and Z positions
	# x = r * cos(theta), z = r * sin(theta)
	var x = cos(time_passed) * radius
	var z = sin(time_passed) * radius
	
	# Apply the position
	global_position = Vector3(x, height, z)
	
	# Optional: Make the model face the direction it's moving
	look_at(global_position + Vector3(-sin(time_passed), 0, cos(time_passed)), Vector3.UP)
