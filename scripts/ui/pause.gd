extends VBoxContainer


# Called when the node enters the scene tree for the first time
func _ready() -> void:
	self.visible = get_tree().paused
	self.process_mode = Node.PROCESS_MODE_ALWAYS


func game_pause() -> void:
	get_tree().paused = true
	self.visible = true
	$"../AimPoint".visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func game_continue() -> void:
	get_tree().paused = false
	self.visible = false
	if not GameManager.player_ref._locked:
		$"../AimPoint".visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.on_game_resume.emit()


# Called every time an input event is received
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			game_continue()
		else:
			game_pause()


func _on_resume_pressed() -> void:
	if get_tree().paused:
		game_continue()
	else:
		game_pause()


func _on_quit_pressed() -> void:
	get_tree().quit()
