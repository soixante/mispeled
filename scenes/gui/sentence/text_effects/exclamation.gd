extends RichTextEffect

class_name ExclamationWordEffect

var bbcode = 'exclamation'

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var time = Time.get_ticks_msec() / 1000.0
	char_fx.color = sin(time * 10 + char_fx.relative_index * 0.5) * char_fx.color
	return true
