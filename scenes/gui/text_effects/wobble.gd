extends RichTextEffect
class_name WobbleEffect

var bbcode = "wobble"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var time = Time.get_ticks_msec() / 1000.0
	char_fx.offset.y += sin(time * 10 + char_fx.relative_index * 0.5) * 5.0
	return true
