extends Node2D

class_name BulletScene

signal player_hit
signal wall_hit

var velocity: Vector2 = Vector2.ZERO
var speed: int = 100
var damage: DamageModel = DamageModel.new(5,DamageModel.PHYSICAL)

func _ready():
	add_to_group('bullets')

func _process(delta: float) -> void:
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_destroy()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		push_error
		SignalsHandler.player_hit.emit(body.get_parent(), damage)
	if body.is_in_group("walls"):
		SignalsHandler.wall_hit.emit(body)
		_destroy()

func _destroy() -> void:
	queue_free()
