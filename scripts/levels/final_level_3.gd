extends BaseLevel

@onready var _plane_container := $PlaneContainer as Node3D
@onready var _fall_area = $FallArea as Area3D
@onready var _endArea = $StartAndEnd/EndArea as Area3D

const WORLD_ENV_LEVEL_3 = preload("uid://b0keyl85g5pfm")

func configure_world_environment(world_environment : WorldEnvironment):
	world_environment.environment = WORLD_ENV_LEVEL_3

func reset_player_pos():
	GameManager.tv_ref.global_position = $StartAndEnd/Plane/TVSocket.global_position
	GameManager.tv_ref.global_rotation = $StartAndEnd/Plane/TVSocket.global_rotation
	GameManager.player_ref.global_position = $StartAndEnd/Plane/PlayerSocket.global_position
	GameManager.player_ref.global_rotation = $StartAndEnd/Plane/PlayerSocket.global_rotation
	
	fade_out_planes()

func on_level_load():
	_fall_area.body_entered.connect(_on_player_entered_gate)
	_endArea.body_entered.connect(_on_player_win)
	reset_player_pos()

	
	
func fade_out_planes():
	var tween = create_tween()
	tween.set_parallel(true) # Fade all planes simultaneously

	for child in _plane_container.get_children():
		var child_mesh = child as MeshInstance3D
		if not child_mesh:
			continue
			

		var mat = child_mesh.get_active_material(0).duplicate()
		child_mesh.set_surface_override_material(0, mat)
		

		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		

		mat.albedo_color.a = 1.0
		
		tween.tween_property(mat, "albedo_color:a", 0.0, 7.0)



func _on_player_entered_gate(body):
	# 2. Check if the body that entered is the player
	if body == GameManager.player_ref:		
		# 3. Call your fade function
		reset_player_pos()
		
func _on_player_win(body):
	if body == GameManager.player_ref:
		GameManager.tv_ref.global_position = $StartAndEnd/Plane11/TVSocket.global_position
		GameManager.tv_ref.global_rotation = $StartAndEnd/Plane11/TVSocket.global_rotation
	
