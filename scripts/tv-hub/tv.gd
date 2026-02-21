class_name TV
extends InteractableObject


@export var tv_codes: TvCodes = preload("res://levels/tv-hub/tv_codes.tres")


@onready var sub_viewport: SubViewport = $Sprite3D/SubViewport
@onready var tv_screen: TvScreen = $Sprite3D/SubViewport/TvScreen
@onready var tv_camera: Camera3D = $TvCamera
@onready var tv_static_effect: MeshInstance3D = $ScreenStaticEffect

var keepable_object = []


var _locked_player: Player = null

#logic to avoid to detect the interact soon but only after the release
var first_time: bool = true
	
func _ready() -> void:
	GameManager.tv_ref = self
	
func _unhandled_input(event: InputEvent) -> void:
	sub_viewport.push_input(event)
	
	#logic to avoid to detect the interact soon but only after the release
	if tv_camera.current and Input.is_action_just_released("interact"):
		first_time = false
	if tv_camera.current and Input.is_action_just_pressed("interact"):
		if !first_time:
			_exit_terminal()
			first_time = true


func _on_code_accepted(code: String) -> void:
	var level = GameManager.get_level(code)
	print(code)
	if level:
		GameManager.load_new_level(level)
	
	tv_screen.animate_shader(true if level else false, tv_static_effect)


func _exit_terminal():
	if is_instance_valid(_locked_player):
		_locked_player.unlock_play()
		var children_cameras: Array[Node] = _locked_player.find_children("*", "Camera3D")
		if not children_cameras.is_empty():
			var camera := children_cameras[0] as Camera3D
			if is_instance_valid(camera):
				camera.current = false
	_locked_player = null
	tv_camera.current = false
	tv_screen.toggle_show_symbol(true)
	
func on_interaction(p: Player) -> void:
	tv_screen.grab_focus()
	_locked_player = p
	p.lock_play()
	var children_cameras: Array[Node] = p.find_children("*", "Camera3D")
	if not children_cameras.is_empty():
		var camera := children_cameras[0] as Camera3D
		if is_instance_valid(camera):
			camera.current = false
	tv_camera.current = true
