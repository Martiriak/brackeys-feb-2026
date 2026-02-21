class_name Duck
extends PickableObject


var goto = Vector3(0.0, 0.0, 0.0)
var is_pick_up = false
var speed = 5.0
var update_direction_seconds = 1.0

var _launch = false;
var _launch_speed = 4.0

@onready var ray : RayCast3D = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.set_wait_time(update_direction_seconds)
	timer.set_autostart(true)
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout)
	
	

func _on_timer_timeout():
	var right_top_edge = Vector2(10, 10)
	var right_bottom_edge = Vector2(-10, -10)
	
	var new_x = randf_range(right_top_edge.x, right_bottom_edge.x)
	var new_z = randf_range(right_top_edge.y, right_bottom_edge.y)
	
	goto = Vector3(new_x, 0.0, new_z )
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_pick_up:
		if goto.distance_to(position) < 0.05:
			return
		var direction = position.direction_to(goto)
		
		rotation.y = atan2(direction.x,direction.z)
		
		if ray.is_colliding():
			goto = position
			return
		
		position += direction * speed * delta
	if _launch:
		var collision = move_and_collide(position +  Vector3(0.0, 0.0, 1.0) * ( 0.5 * 9.81 * pow(delta, 2)) + _launch_speed * delta * rotation)
		if collision:
			_launch = false
			
func launch(player_position: Vector3) -> void:
	position = player_position
	_launch = true
	
	 

	
