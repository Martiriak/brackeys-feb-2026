extends SpotLight3D

func _ready():
 flash()

func flash():
 light_energy = randf()
 await get_tree().create_timer(randf_range(0.10, 0.40)).timeout
 flash()
