extends Control


@export var code_levels_map: CodeLevelMap
@export
var symbols: Array[CompressedTexture2D] = [
		preload("res://assets/symbols/symbol_1.png"),
		preload("res://assets/symbols/symbol_2.png"),
		preload("res://assets/symbols/symbol_3.png"),
]
@export
var no_symbol: CompressedTexture2D = preload("res://assets/symbols/no_symbol.png")


func _ready() -> void:
	# Fetch the digits of the code.
	var code_digits: Array[int] = []
	var skip_char: bool = false
	for digit in code_levels_map.first_level_code:
		if skip_char:
			skip_char = false
			continue
		if digit == "-":
			skip_char = true
			code_digits.append(-1)
		else:
			code_digits.append(int(digit))
	
	# Assign the symbols.
	var children := $CenterContainer/Slots.get_children()
	for node_index: int in range(children.size()):
		var slot := children[node_index] as TextureRect
		if is_instance_valid(slot):
			if code_digits[node_index] < 0:
				slot.texture = no_symbol
			else:
				slot.texture = symbols[code_digits[node_index]]
