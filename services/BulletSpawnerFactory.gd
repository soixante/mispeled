extends Node
# add a bulletspawner to a ShootingTargetNode from json config

var BulletSpawnerScene := preload("res://scenes/tools/bullet_spawner.tscn")
const DEFAULT_CONFIG: Dictionary = {
	'initial_vector':  Vector2(0, 1),
	'channeling': 5,
	'cooldown': 2,
 	'cadence': 1.0,
 	'bullet_count': 1,
 	'bullet_arc':0,
	'update_on_cadence': true,
 	'targetted': false,
	'target_position': Vector2.ZERO,
}

func create_spawner(target: TargetScene, position: Vector2, config: Dictionary = DEFAULT_CONFIG):
	var spawner = BulletSpawnerScene.instantiate()
	spawner.global_position = position

	for key in DEFAULT_CONFIG.keys():
		if key in spawner and key in config.keys():
			spawner.set(key, config[key])
		else:
			if not key in spawner:
				push_warning("BulletSpawner has no property named '%s'" % key)
			if !key in config.keys():
				spawner.set(key, DEFAULT_CONFIG[key])
	
	spawner.set_arc_vectors()
	if spawner.targetted:
		spawner.add_to_group('aimed_spawners')
	target.add_bullet_spawner(spawner)
	return spawner
