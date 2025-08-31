extends Node2D

@export var initial_vector: Vector2 = Vector2(0, 1)
@export var rotation_step: int = 5
@export var channeling:int = 5
@export var cooldown:int = 2
@export var cadence: float = 1.0
@export var bullet_count: int  = 1
@export var bullet_arc: int = 0
@export var bullet_node: PackedScene
@export var update_on_cadence: bool = true
@export var aim_at_player: bool = false

var tick := 0.0
var second_tick := 0.0
var cadence_tick := 0.0

var current_cooldown := cooldown
var current_channeling := 0

var current_vector:= initial_vector
var current_rot:= 0.0

var arc_vectors = PackedInt32Array()

var on_second = true
var on_cadence = true
var on_cooldown = false

func _ready():
	add_to_group('spawners')
	set_arc_vectors()
	current_cooldown = cooldown
	pass

func _process(delta: float) -> void:
	tick += delta
	second_tick += delta
	cadence_tick += delta
	if second_tick > 1:
		second_tick -= 1.0
		on_second = true
	if cadence_tick > (1 / cadence):
		cadence_tick -= 1 / cadence
		on_cadence = true
	
	if on_second:
		_on_second_activity()
		on_second = false
	
	if on_cadence:
		_on_cadence_activity()
		on_cadence = false

func _on_second_activity() -> void:
	if on_cooldown:
		current_cooldown-=1
		if current_cooldown <= 0:
			current_cooldown = cooldown
			on_cooldown = false	
	else:
		current_channeling+=1
		if (current_channeling == channeling):
			current_channeling = 0
			on_cooldown = true
	if !update_on_cadence: 
		update_spawner()

func _on_cadence_activity() -> void:
	if !on_cooldown:
		if  update_on_cadence:
			update_spawner()
		spawn_bullets()

func update_spawner():
	if aim_at_player:		
		pass
	else:
		current_vector = initial_vector.rotated(current_rot)
		current_rot += rotation_step * PI / 180.0
	
func spawn_bullets():
	for i in bullet_count:
		var bullet = bullet_node.instantiate()
		var arc_vector = current_vector.rotated(arc_vectors[i] * PI / 180.0)
		bullet.position = global_position
		bullet.velocity = arc_vector * bullet.speed
		get_tree().current_scene.add_child(bullet)

func set_arc_vectors():
	if bullet_count == 1:
		arc_vectors.append(0)
	else:
		@warning_ignore("integer_division")
		var angle = round( bullet_arc / (bullet_count - 1))
		
		@warning_ignore("integer_division")
		arc_vectors.append(- round(bullet_arc / 2 ))
		for i in (bullet_count - 1):
			arc_vectors.append(arc_vectors[0] + (angle * (1+i)))
