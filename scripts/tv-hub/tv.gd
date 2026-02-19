class_name TV
extends InteractableObject


@export var tv_codes: TvCodes = preload("res://levels/tv-hub/tv_codes.tres")


@onready var sub_viewport: SubViewport = $Sprite3D/SubViewport
@onready var tv_screen: TvScreen = $Sprite3D/SubViewport/TvScreen
@onready var tv_camera: Camera3D = $TvCamera

var keepable_object = []

func _unhandled_input(event: InputEvent) -> void:
	sub_viewport.push_input(event)


func _on_code_accepted(code: String) -> void:
	print(code)
	# TODO: check if code corresponds to one that can change the scene.
	# USE tv_codes!


func on_interaction(p: Player) -> void:
	var children_cameras: Array[Node] = p.find_children("*", "Camera3D")
	if not children_cameras.is_empty():
		var camera := children_cameras[0] as Camera3D
		if is_instance_valid(camera):
			camera.current = false
			tv_camera.current = true
