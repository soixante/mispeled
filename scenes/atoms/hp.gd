extends Node2D

class_name HPScene

@export var entity: PlayerScene

@onready var sprite:= $Sprite2D

func _ready():
	pass

func _process(delta: float) -> void:
	if entity:
		var max_hp = entity.get('maxhp')
		var percentage:int = round(entity.get('hp') / max_hp * 100) - 6

		sprite.material.set('shader_parameter/percentage_hp_left', percentage)
	
