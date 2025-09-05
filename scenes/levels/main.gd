extends Node2D

const ESC_HOLD_THRESHOLD = 2

var input_buffer: String = ""
var esc_hold_time: float = 0.0

@onready var player = $Player
@onready var target = $Target

func _ready() -> void:
	SignalsHandler.player_hit.connect(_on_player_hit)
	SignalsHandler.wall_hit.connect(_on_wall_hit)
	SignalsHandler.target_sentence_typed.connect(_on_target_sentence_typed)
	
	#BulletSpawnerFactory.create_spawner(target, Vector2.ZERO, {})
	#BulletSpawnerFactory.create_spawner(target, Vector2.ZERO, {'bullet_count': 3, 'bullet_arc': 10, 'targetted': true})

func _process(delta: float) -> void:
	for spawner in get_tree().get_nodes_in_group("aimed_spawners"):
		spawner.set_target_position(player.body_position)
		
	if Input.is_key_pressed(KEY_ESCAPE):
		esc_hold_time += delta
		if esc_hold_time >= ESC_HOLD_THRESHOLD:
			get_tree().quit()
	else:
		esc_hold_time = 0.0
	
func _on_player_hit(player: CharacterBody2D) -> void:
	pass
	
func _on_wall_hit(wall: StaticBody2D) -> void:
	pass

func _on_target_sentence_typed(target: Node2D) -> void:
	target.destroy()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		match event.keycode:
			KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_SHIFT, KEY_ALT, KEY_CAPSLOCK:
				return
			KEY_BACKSPACE:
				if (input_buffer.length() > 0):
					input_buffer = input_buffer.substr(0, input_buffer.length() - 1)
					validate_input_buffer()
				return
			KEY_ESCAPE:
				input_buffer = ""
				validate_input_buffer()
				return
		
		if event.unicode > 0:
			var character = char(event.unicode)
			input_buffer += character
			input_buffer = input_buffer.right(300)
			validate_input_buffer()
		
func validate_input_buffer() -> void:
	for current_target in get_tree().get_nodes_in_group("targets"):
		var to_match = current_target.get_sentence()
		
		# full match
		if (input_buffer.ends_with(to_match)):
			SignalsHandler.target_sentence_typed.emit(current_target)
			input_buffer = ""
		
		var incomplete_matched := 0
		for i in range(to_match.length() -1 , 0, -1):
			var incomplete_match = to_match.substr(0,i);
			if (input_buffer.ends_with(incomplete_match)):
				current_target.highlight_sentence(incomplete_match.length())
				incomplete_matched = incomplete_match.length()		
				break
		
		current_target.highlight_sentence(incomplete_matched)
		
