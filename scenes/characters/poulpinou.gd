extends Node2D

class_name TargetScene

@export var sentence := ""

@onready var Sentence := $sentence
@onready var AnimatedSprite := $CharacterBody2D/AnimatedSprite2D

var player_position: Vector2
var BulletSpawners: Array[BulletSpawner] = []

func _ready() -> void:
	add_to_group('targets')
	AnimatedSprite.play("default")
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
	for spawner in BulletSpawners:
		if spawner and spawner.is_inside_tree():
			spawner.queue_free()
	if Sentence and Sentence.is_inside_tree():
		Sentence.queue_free()
		
	AnimatedSprite.stop()		
	AnimatedSprite.play('death')
	await AnimatedSprite.animation_finished
	queue_free()

func shoot()->void:
	pass
	
func get_sentence() -> String:
	return sentence

func highlight_sentence(len: int) -> void:
	if len == 0:
		Sentence.text = sentence
		return
	
	var correct = sentence.substr(0, len)
	var remaining = sentence.substr(len)
	
	Sentence.text="[color=green]"+correct+"[/color]"+remaining
	
