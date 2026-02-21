extends Node3D

@export var seconds : float;
@export var direction : Vector3;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * delta;
	seconds -= delta
	if seconds <= 0.0:
		queue_free()
	pass
