extends RichTextLabel

func _ready() -> void:
	var wobble = WobbleEffect.new()
	install_effect(wobble)
	print 
