extends Node

const ESC_HOLD_THRESHOLD = 2

var input_buffer: String = ""
var esc_hold_time: float = 0.0
var capture = true

@onready var au_key_pressed = $key_pressed
@onready var au_backspace_pressed = $backspace_pressed

func _input(event: InputEvent) -> void:
	if (!capture):
		return
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		SignalsHandler.key_pressed.emit(event)
		match event.keycode:
			KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_SHIFT, KEY_ALT, KEY_CAPSLOCK:
				return
			KEY_BACKSPACE:
				au_backspace_pressed.play()
				if (input_buffer.length() > 0):
					input_buffer = input_buffer.substr(0, input_buffer.length() - 1)
					_validate_input_buffer()
				return
			KEY_ESCAPE:
				input_buffer = ""
				_validate_input_buffer()
				return
		
		if event.unicode > 0:
			au_key_pressed.play()
			var character = char(event.unicode)
			input_buffer += character
			input_buffer = input_buffer.right(300)
			
			_validate_input_buffer()


func _validate_input_buffer() -> void:
	for current_sentence: Sentence in get_tree().get_nodes_in_group("sentences"):
		current_sentence.validate(input_buffer)
