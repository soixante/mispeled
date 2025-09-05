extends CharacterBody2D

@export var walk_speed:= 400

func _ready() -> void:
	add_to_group('players')
	
func get_input():
	var input_direction = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	velocity = input_direction * walk_speed

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
