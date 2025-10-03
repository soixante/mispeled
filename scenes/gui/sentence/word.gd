extends Node

class_name Word

var word: String
var effects: Array = []

func _ready() -> void:
	pass

func _init(init_word: String, init_effects: Array) -> void:
	word = init_word.strip_edges()
	effects = init_effects.duplicate() if init_effects else []

func _get_effect_wrappers() -> Dictionary:
	var start_effect = ""
	var end_effect = ""
	for effect in effects:
		start_effect += "[" + effect + "]"
		end_effect = "[/" + effect + "]" + end_effect
	return {
		"start": start_effect,
		"end": end_effect
	}
	
func cook() -> String:
	var wrappers = _get_effect_wrappers()
	return wrappers.start + word + wrappers.end

func cook_highlight(len: int) -> String:
	var wrappers = _get_effect_wrappers()
	if len <= 0:
		return  wrappers.start + word + wrappers.end
	elif len >= word.length():
		return wrappers.start + "[color=green]" + word + "[/color]" + wrappers.end
	else:
		var correct = word.substr(0, len)
		var rest = word.substr(len)
		return wrappers.start + "[color=green]" + correct + "[/color]" + rest + wrappers.end
	
