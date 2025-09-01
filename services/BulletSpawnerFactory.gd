extends Node
# add a bulletspawner to a ShootingTargetNode from json config

var BulletSpawnerScene := preload("res://scenes/tools/bullet_spawner.tscn")

func create_spawner(parent: TargetScene, position: Vector2, config: Dictionary = {}):
	var spawner = BulletSpawnerScene.instantiate()
	parent.add_child(spawner)
	spawner.global_position = position
	
	for key in config.keys():
		if key in spawner:
			spawner.set(key, config[key])
		else:
			push_warning("BulletSpawner has no property named '%s'" % key)
	
	spawner.set_arc_vectors()		
	return spawner
