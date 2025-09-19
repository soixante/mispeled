extends Node2D

const ESC_HOLD_THRESHOLD = 2

var input_buffer: String = ""
var esc_hold_time: float = 0.0

@onready var player = $Player
@onready var target = $Target
@onready var hp = $hp

var GameOverScene = preload("res://scenes/atoms/game_over.tscn")
var _game_over:= false

func _ready() -> void:
	SignalsHandler.player_hit.connect(_on_player_hit)
	SignalsHandler.player_death.connect(_on_player_death)
	SignalsHandler.wall_hit.connect(_on_wall_hit)
	SignalsHandler.target_sentence_typed.connect(_on_target_sentence_typed)

	RenderingServer.set_default_clear_color(Color.DARK_KHAKI)
	
	if hp:
		hp.set('entity', player)
	else:
		push_error('hp has no set_entity method')
	
	BulletSpawnerFactory.create_spawner(target, Vector2.ZERO, {})
	BulletSpawnerFactory.create_spawner(target, Vector2.ZERO, {'bullet_count': 3, 'bullet_arc': 10, 'targetted': true})

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		esc_hold_time += delta
		if esc_hold_time >= ESC_HOLD_THRESHOLD:
			get_tree().quit()
	else:
		esc_hold_time = 0.0
		
	if not _game_over:
		for spawner in get_tree().get_nodes_in_group("aimed_spawners"):
			spawner.set_target_position(player.body_position)
		
		
func _on_player_hit(player: PlayerScene, damage: DamageModel) -> void:
	if (player.has_method('take_damage')):
		player.take_damage(damage)
	else:
		push_error('no take_damage func')

func _on_player_death(player: PlayerScene) -> void:
	var game_over_ui = GameOverScene.instantiate()
	var viewport_size = get_viewport_rect().size
	game_over_ui.position = viewport_size / 2
	game_over_ui.scale = Vector2(3, 3)
	add_child(game_over_ui)
	_game_over = true
	
	
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
		
