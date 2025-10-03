extends RichTextEffect

var bbcode = 'ghost'

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var time = Time.get_ticks_msec() / 1000.0
	var alpha = sin(time*5) * char_fx.color.a
	char_fx.color.a = alpha
	return true
