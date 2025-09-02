extends Node2D

class_name TargetScene

@export var sentence := ""

@onready var Sentence := $sentence

var player_position: Vector2
var BulletSpawners: Array[BulletSpawner] = []

func _ready() -> void:
	add_to_group('targets')
	Sentence.text = sentence

func set_aiming_targets_group():
	for bs in BulletSpawners:
		if bs.targetted:
			add_to_group('aiming_targets')
			return
	
	remove_from_group('aiming_targets')

	
func add_bullet_spawner(bullet_spawner: BulletSpawner) -> int:
	BulletSpawners.push_back(bullet_spawner)
	add_child(bullet_spawner)
	set_aiming_targets_group()
	return BulletSpawners.size()
	
func remove_bullet_spawner(bullet_spawner: BulletSpawner) -> int:
	BulletSpawners.erase(bullet_spawner)
	remove_child(bullet_spawner)
	set_aiming_targets_group()
	return BulletSpawners.size()

func _process(delta: float) -> void:
	for bs in BulletSpawners:
		if bs.targetted:
			bs.target_position = player_position

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
	
