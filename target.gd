extends Node2D

@export var sentence := ""

@onready var Sentence := $sentence
@onready var BulletSpawner := $bullet_spawner

var player_position: Vector2

func _ready() -> void:
	add_to_group('targets')
	if BulletSpawner.targetted:
		add_to_group('aiming_targets')
	Sentence.text = sentence
	
func _process(delta: float) -> void:
	if BulletSpawner.targetted:
		BulletSpawner.target_position = player_position

func set_player_position(pos: Vector2) -> void:
	player_position = pos
	
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
	
