extends Node3D

@export var center_position: Vector3 = Vector3.ZERO
@export var radius: float = 5.0
@export var speed: float = -2.0
@export var noise_strength: float = 0.5  # How much it wobbles
@export var toggle_duration: float = 5.0

var height: float = 0.0
var time_passed: float = 0.0
var noise_time: float = 0.0
var _jumping: bool = false
var is_active: bool = true

# Noise generator for the trajectory wobble
var noise = FastNoiseLite.new()

func _ready() -> void:
	noise.seed = randi()
	noise.frequency = 0.5 # Higher = shakier, Lower = smoother
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = toggle_duration
	timer.autostart = true
	timer.timeout.connect(func(): is_active = !is_active)

func _process(delta: float) -> void:
	if not is_active:
		return
		
	time_passed += delta * speed
	
	# 1. Base Circular Math
	var x = cos(time_passed) * radius
	var z = sin(time_passed) * radius
	
	# 2. Multi-Layered Noise 
	# We sample the noise map at different coordinates for X and Z 
	# to ensure the "wobble" isn't just a diagonal line.
	var nx = noise.get_noise_2d(noise_time, 0.0) * noise_strength
	var nz = noise.get_noise_2d(0.0, noise_time) * noise_strength
	var ny = noise.get_noise_2d(noise_time, noise_time) * (noise_strength * 0.5)
	
	# 3. Combine with Center
	# Added noise to Y as well for a "floating" jitter
	global_position = center_position + Vector3(x + nx, height + ny, z + nz)
	
	# Face the direction of movement (tangent)
	var forward_vector = Vector3(-sin(time_passed), 0, cos(time_passed))
	if forward_vector != Vector3.ZERO:
		look_at(global_position + forward_vector, Vector3.UP)
	
	# Random Jump Logic
	if randf() > 0.995 && !_jumping:
		_jumping = true
		start_parabolic_jump(5.0, 1.5)

func start_parabolic_jump(peak_height: float, duration: float):
	var tween = create_tween()
	# Up
	tween.tween_property(self, "height", peak_height, duration / 2)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Down
	tween.tween_property(self, "height", 0.0, duration / 2)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	tween.finished.connect(func(): _jumping = false)
