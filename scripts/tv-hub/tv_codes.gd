class_name TvCodes
extends Resource


@export
var codes_to_maps: Dictionary[String, PackedScene]


func verify_code(code: String) -> bool:
	return code in codes_to_maps


func get_map_with_code(code: String) -> PackedScene:
	return codes_to_maps.get(code)
