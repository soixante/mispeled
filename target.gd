extends Node2D

@export var sentence := ""

@onready var Sentence := $sentence

func _ready() -> void:
	add_to_group('targets')
	Sentence.text = sentence

func destroy()-> void:
	queue_free()
	
func get_sentence() -> String:
	return sentence

func highlight_sentence(len: int) -> void:
	if len == 0:
		Sentence.text = sentence
		return
	
	var correct = sentence.substr(0, len)
	var remaining = sentence.substr(len)
	
	Sentence.text="[color=green]"+correct+"[/color]"+remaining
	
