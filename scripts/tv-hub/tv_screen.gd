class_name TvScreen
extends Control


@export
var symbols: Array[CompressedTexture2D] = [
		preload("res://assets/symbols/symbol_1.png"),
		preload("res://assets/symbols/symbol_2.png"),
		preload("res://assets/symbols/symbol_3.png"),
]
@export
var no_symbol: CompressedTexture2D = preload("res://assets/symbols/no_symbol.png")

@onready var _shader_rect := $ColorRect as ColorRect
@onready var _active_slot_indicator := $CenterContainer/ActiveSlotIndicator as Control
@onready var _hint_image := $CenterContainer/Hint as TextureRect
@onready var _symbol_container := $CenterContainer/Slots as HBoxContainer

var _slots: Array[TextureRect]
var _symbols_for_slots: Array[int]
var _active_slot: int = 0

var _shader_timeline: float = 0.0
var _flash_tween: Tween
var _is_empty: bool = true

signal code_accepted(code: String)

func hide_active_slot_indicator():
	_active_slot_indicator.hide()

func set_code(code: Array[int]):
	assert(code.size() == _symbols_for_slots.size())
	for i in code.size():
		_symbols_for_slots[i] = code[i]
		_slots[i].texture = symbols[_symbols_for_slots[i]]


func _animate_wrong_code(value: float):
	_shader_rect.material.set_shader_parameter("target_res", 64.0)
	_shader_rect.material.set_shader_parameter("pixel_progress", value)
	_shader_rect.material.set_shader_parameter("color_progress", value)
	_shader_timeline = value
	
	if _shader_timeline < 0.8 and not _is_empty:
		reset_symbols()

func _animate_right_code(value: float):
	_shader_rect.material.set_shader_parameter("extreme_res", 2.0)
	_shader_rect.material.set_shader_parameter("pixel_progress", value)
	_shader_rect.material.set_shader_parameter("color_progress", value)
	_shader_timeline = value
	
	if _shader_timeline < 0.7 and not _is_empty:
		reset_symbols()
		toggle_show_symbol(false)

func animate_shader(is_code_correct : bool):
	
	var flash_color = Color.GREEN
	var animate_fun = _animate_right_code
	var max_duration = 2.0
	var min_value = 0.0
	
	if not is_code_correct:
		flash_color = Color.RED
		animate_fun = _animate_wrong_code
		max_duration = 1.0
		min_value = 0.0
	
	_shader_rect.material.set_shader_parameter("pixel_progress", 1.0)
	_shader_rect.material.set_shader_parameter("color_progress", 1.0)
	_shader_rect.material.set_shader_parameter("flash_color", flash_color)

	
	
	if _flash_tween:
		_flash_tween.kill()
	
	_flash_tween = create_tween()
	
	# 3. Animate it back to 0.0 over 0.5 seconds (Fade effect OFF)
	_flash_tween.tween_method(animate_fun, 1.0, min_value, max_duration) 
	
	_flash_tween.set_trans(Tween.TRANS_CUBIC)
	_flash_tween.set_ease(Tween.EASE_IN)

func toggle_show_symbol(show_symbol : bool):
	_symbol_container.visible = show_symbol
	_hint_image.visible = !show_symbol

func get_current_code() -> String:
	var result: String = ""
	for symbol_id in _symbols_for_slots:
		result += str(symbol_id)
	return result


func accept_current_code() -> void:
	code_accepted.emit(get_current_code())


func reset_symbols() -> void:
	_is_empty = true
	for index: int in range(0, _slots.size()):
		_slots[index].texture = no_symbol
		_symbols_for_slots[index] = -1


func set_active_slot(new_active_slot: int) -> void:
	_active_slot = new_active_slot
	_active_slot_indicator.get_parent().remove_child(_active_slot_indicator)
	_slots[_active_slot].add_child(_active_slot_indicator)
	_active_slot_indicator.position = Vector2(0.0, 72.0)


func _gui_input(event: InputEvent) -> void:
	var is_tween_playing = _flash_tween and _flash_tween.is_running()
	if GameManager.player_ref and GameManager.player_ref._locked and not is_tween_playing:
		if event.is_action_pressed("ui_accept"):
			accept_current_code()
		
		elif event.is_action_pressed("ui_left"):
			set_active_slot((_active_slot - 1) % _slots.size())
			
		elif event.is_action_pressed("ui_right"):
			set_active_slot((_active_slot + 1) % _slots.size())
		
		elif event.is_action_pressed("ui_up"):
			_symbols_for_slots[_active_slot] = (_symbols_for_slots[_active_slot] + 1) % symbols.size()
			_slots[_active_slot].texture = symbols[_symbols_for_slots[_active_slot]]
			_is_empty = false
		elif event.is_action_pressed("ui_down"):
			_symbols_for_slots[_active_slot] -= 1
			if _symbols_for_slots[_active_slot] < 0:
				_symbols_for_slots[_active_slot] = symbols.size() - 1
			_slots[_active_slot].texture = symbols[_symbols_for_slots[_active_slot]]
			_is_empty = false;


func _ready() -> void:
	grab_focus() # TESTING!
	for widget in $CenterContainer/Slots.get_children():
		var slot := widget as TextureRect
		if is_instance_valid(slot):
			_slots.append(slot)
			_symbols_for_slots.append(-1)
			slot.texture = no_symbol
	
	await get_tree().process_frame
	set_active_slot(0)
