extends SpotLight3D

@onready var light_constant_player = $light_constant_player
@onready var light_flicker_player = $light_flicker_player


func _ready():
	light_constant_player.play()
	flash()

func flash():
	do_flickering(3, 0.2)
	await get_tree().create_timer(randf_range(4, 7)).timeout
	flash()

func do_flickering(how_many : int, min_wait : float, max_wait : float = min_wait) -> void:
	for i in how_many:
		light_energy = !light_energy
		if light_energy:
			light_flicker_player.play()
		await get_tree().create_timer(randf_range(min_wait, max_wait)).timeout
	light_energy = 1.0
