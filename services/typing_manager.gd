extends Node

const ESC_HOLD_THRESHOLD = 2

var input_buffer: String = ""
var esc_hold_time: float = 0.0
var capture = true

func _input(event: InputEvent) -> void:
	if (!capture):
		return
	
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		match event.keycode:
			KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_SHIFT, KEY_ALT, KEY_CAPSLOCK:
				return
			KEY_BACKSPACE:
				if (input_buffer.length() > 0):
					input_buffer = input_buffer.substr(0, input_buffer.length() - 1)
					#validate_input_buffer()
				return
			KEY_ESCAPE:
				input_buffer = ""
				#validate_input_buffer()
				return
		
		if event.unicode > 0:
			#audio.play()
			var character = char(event.unicode)
			input_buffer += character
			input_buffer = input_buffer.right(300)
			
			for current_sentence: Sentence in get_tree().get_nodes_in_group("sentences"):
				current_sentence.validate(input_buffer)
