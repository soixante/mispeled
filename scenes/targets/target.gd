extends Node2D

class_name TargetScene

@export var sentence := ""

@onready var Sentence := $sentence

var player_position: Vector2
var BulletSpawners: Array[BulletSpawner] = []

func _ready() -> void:
	add_to_group('targets')
	Sentence.text = sentence
	
func add_bullet_spawner(bullet_spawner: BulletSpawner) -> int:
	BulletSpawners.push_back(bullet_spawner)
	add_child(bullet_spawner)
	return BulletSpawners.size()
	
func remove_bullet_spawner(bullet_spawner: BulletSpawner) -> int:
	BulletSpawners.erase(bullet_spawner)
	remove_child(bullet_spawner)
	return BulletSpawners.size()

func _process(delta: float) -> void:
	pass
	
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
	
