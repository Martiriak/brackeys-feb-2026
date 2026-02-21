extends SpotLight3D

func _ready():
	flash()

func flash():
	do_flickering(3, 0.2)
	await get_tree().create_timer(randf_range(4, 7)).timeout
	flash()

func do_flickering(how_many : int, min_wait : float, max_wait : float = min_wait) -> void:
	for i in how_many:
		light_energy = !light_energy
		await get_tree().create_timer(randf_range(min_wait, max_wait)).timeout
	light_energy = 1.0
