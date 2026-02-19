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

@onready var _active_slot_indicator := $CenterContainer/ActiveSlotIndicator as Control

var _slots: Array[TextureRect]
var _symbols_for_slots: Array[int]
var _active_slot: int = 0


signal code_accepted(code: String)


func get_current_code() -> String:
	var result: String = ""
	for symbol_id in _symbols_for_slots:
		result += str(symbol_id)
	return result


func accept_current_code() -> void:
	code_accepted.emit(get_current_code())
	reset_symbols()


func reset_symbols() -> void:
	for index: int in range(0, _slots.size()):
		_slots[index].texture = no_symbol
		_symbols_for_slots[index] = -1


func set_active_slot(new_active_slot: int) -> void:
	_active_slot = new_active_slot
	_active_slot_indicator.get_parent().remove_child(_active_slot_indicator)
	_slots[_active_slot].add_child(_active_slot_indicator)
	_active_slot_indicator.position = Vector2(0.0, 72.0)


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		accept_current_code()
	
	elif event.is_action_pressed("ui_left"):
		set_active_slot((_active_slot - 1) % _slots.size())
		
	elif event.is_action_pressed("ui_right"):
		set_active_slot((_active_slot + 1) % _slots.size())
	
	elif event.is_action_pressed("ui_up"):
		_symbols_for_slots[_active_slot] = (_symbols_for_slots[_active_slot] + 1) % symbols.size()
		_slots[_active_slot].texture = symbols[_symbols_for_slots[_active_slot]]
	elif event.is_action_pressed("ui_down"):
		_symbols_for_slots[_active_slot] -= 1
		if _symbols_for_slots[_active_slot] < 0:
			_symbols_for_slots[_active_slot] = symbols.size() - 1
		_slots[_active_slot].texture = symbols[_symbols_for_slots[_active_slot]]


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
