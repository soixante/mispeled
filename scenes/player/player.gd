extends Node2D

class_name PlayerScene

@onready var body := $CharacterBody2D

@export var maxhp:= 100.0
@export var hp:= maxhp

@export var body_position: Vector2:
	get:
		return body.global_position

func take_damage(damage: DamageModel) -> void:
	hp -= damage.damage
	if hp <= 0:
		SignalsHandler.player_death.emit(self)
		_death()

func _death() -> void:
	queue_free()
