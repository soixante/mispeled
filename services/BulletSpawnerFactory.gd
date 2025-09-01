extends Node

var BulletSpawnerScene := preload("res://scenes/tools/bullet_spawner.tscn")

func create_spawner(parent: Node, position: Vector2, config: Dictionary = {}):
	var spawner = BulletSpawnerScene.instantiate()
	parent.add_child(spawner)
	spawner.global_position = position
	
	# properties from config
	for key in config.keys():
		if spawner.has_variable(key):
			spawner.set(key, config[key])
		else:
			push_warning("BulletSpawner has no property named '%s'" % key)
			
	return spawner
