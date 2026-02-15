extends Node

const ESC_HOLD_THRESHOLD = 2
const CAPTURE_MODE_MAIN = 1
const CAPTURE_MODE_MENU = 2

enum CaptureMode {
	MAIN,
	MENU,
	CREDITS,
}

var input_buffer: String = ""
var esc_hold_time: float = 0.0
var capture = CaptureMode.MAIN

@onready var au_key_pressed = $key_pressed
@onready var au_backspace_pressed = $backspace_pressed
func _ready() -> void:
	SignalsHandler.sentence_typed.connect(_on_sentence_typed)

func _input(event: InputEvent) -> void:
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
		
func _on_sentence_typed(sentence: Sentence) -> void:
	_set_capture_mode(CaptureMode.MENU)

func _set_capture_mode(mode: int) -> void:
	if (capture & mode):
		return
	if (mode & CaptureMode.MENU):
		au_backspace_pressed.volume_db -= 15.0
		au_key_pressed.volume_db -= 15.0
	if (mode & CaptureMode.MAIN):
		au_backspace_pressed.volume_db += 15.0
		au_key_pressed.volume_db += 15.0
