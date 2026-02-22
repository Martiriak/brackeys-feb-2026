class_name SodaCan
extends InteractableObject

@export var levelCode : Array[int] = [0, 2, 0, 2, 0]

@onready var can_camera: Camera3D = $CanCamera
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var tv_screen: TvScreen = $Sprite3D/SubViewport/TvScreen

var _locked_player: Player = null

var bFirstTime : bool = true

func enable_camera():
	can_camera.current = true
	
func disable_camera():
	can_camera.current = false

func get_string_to_print():
	return '"E" to look at:' + self.name

func show_code():
	sprite_3d.show()
	tv_screen.hide_active_slot_indicator()

func hide_code():
	sprite_3d.hide()
	
func _ready() -> void:
	tv_screen.set_code(levelCode)

func on_interaction(p: Player) -> void:
	_locked_player = p
	p.lock_play()
	var children_cameras: Array[Node] = p.find_children("*", "Camera3D")
	if not children_cameras.is_empty():
		var camera := children_cameras[0] as Camera3D
		if is_instance_valid(camera):
			camera.current = false
	enable_camera()
	

func _unhandled_input(event: InputEvent) -> void:
	#logic to avoid to detect the interact soon but only after the release	
	if can_camera.current and event.is_action_released("interact"):
		if !bFirstTime:
			if is_instance_valid(_locked_player):
				_locked_player.unlock_play()
				var children_cameras: Array[Node] = _locked_player.find_children("*", "Camera3D")
				if not children_cameras.is_empty():
					var camera := children_cameras[0] as Camera3D
					if is_instance_valid(camera):
						camera.current = true
			_locked_player = null
			disable_camera()
			bFirstTime = true
		else:
			bFirstTime = false
