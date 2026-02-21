class_name TV
extends InteractableObject


@export var tv_codes: TvCodes = preload("res://levels/tv-hub/tv_codes.tres")
@export var sound_accept: AudioStream = preload("res://SFX/TV_Accept.wav")
@export var sound_error: AudioStream  = preload("res://SFX/TV_Error.wav")
@export var sound_tv_ambience: AudioStream  = preload("res://SFX/TV_Ambience.wav")
@export var sound_tv_interact: AudioStream  = preload("res://SFX/TV_Interact.wav")


@onready var sub_viewport: SubViewport = $Sprite3D/SubViewport
@onready var tv_screen: TvScreen = $Sprite3D/SubViewport/TvScreen
@onready var tv_camera: Camera3D = $TvCamera
@onready var tv_static_effect: MeshInstance3D = $ScreenStaticEffect

@onready var sfx_player: AudioStreamPlayer3D = $sfx_player
@onready var ambience_player: AudioStreamPlayer3D = $ambience_player

var keepable_object = []


var _locked_player: Player = null

#logic to avoid to detect the interact soon but only after the release
var first_time: bool = true


func _ready() -> void:
	GameManager.tv_ref = self
	ambience_player.stream = sound_tv_ambience
	ambience_player.play()
	# Creates a slow, eerie pitch wobble
	var tween = create_tween().set_loops()
	tween.tween_property(ambience_player, "pitch_scale", 0.75, 3.0).set_trans(Tween.TRANS_SINE)
	tween.tween_property(ambience_player, "pitch_scale", 0.85, 3.0).set_trans(Tween.TRANS_SINE)
	
	
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
	var level : LevelEntry = GameManager.get_level(code)
	
	if level and level.scene:
		GameManager.load_new_level(level.scene)
		sfx_player.stream = sound_accept
		sfx_player.play()
		tv_screen.set_hint_texture(level.preview_texture)
		tv_screen.animate_shader(true, tv_static_effect)
	else:
		sfx_player.stream = sound_error
		sfx_player.play()
		tv_screen.animate_shader(false, tv_static_effect)



func _exit_terminal():
	if is_instance_valid(_locked_player):
		_locked_player.unlock_play()
		sfx_player.stream = null
		ambience_player.play()
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
	ambience_player.stop()
	sfx_player.stream = sound_tv_interact
	sfx_player.play()
	var children_cameras: Array[Node] = p.find_children("*", "Camera3D")
	if not children_cameras.is_empty():
		var camera := children_cameras[0] as Camera3D
		if is_instance_valid(camera):
			camera.current = false
	tv_camera.current = true
