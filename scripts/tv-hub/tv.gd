class_name TV
extends InteractableObject


@export var tv_codes: TvCodes = preload("res://levels/tv-hub/tv_codes.tres")


@onready var sub_viewport: SubViewport = $Sprite3D/SubViewport
@onready var tv_screen: TvScreen = $Sprite3D/SubViewport/TvScreen
@onready var tv_camera: Camera3D = $TvCamera

var keepable_object = []


var _locked_player: Player = null


func _unhandled_input(event: InputEvent) -> void:
	sub_viewport.push_input(event)


func _on_code_accepted(code: String) -> void:
	if not tv_codes:
		tv_screen.animate_shader(true)
	
	if not tv_codes.verify_code(code):
		tv_screen.animate_shader(true)
		return
	
	# TODO: check if code corresponds to one that can change the scene.
	# USE tv_codes!
	if is_instance_valid(_locked_player):
		_locked_player.unlock_play()
		var children_cameras: Array[Node] = _locked_player.find_children("*", "Camera3D")
		if not children_cameras.is_empty():
			var camera := children_cameras[0] as Camera3D
			if is_instance_valid(camera):
				camera.current = false
	_locked_player = null
	tv_camera.current = false


func on_interaction(p: Player) -> void:
	_locked_player = p
	p.lock_play()
	var children_cameras: Array[Node] = p.find_children("*", "Camera3D")
	if not children_cameras.is_empty():
		var camera := children_cameras[0] as Camera3D
		if is_instance_valid(camera):
			camera.current = false
	tv_camera.current = true
