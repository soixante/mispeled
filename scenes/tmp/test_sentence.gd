extends Node2D

var SentenceScene = preload("res://scenes/gui/sentence/sentence.tscn")

func _ready() -> void:
	var words: Array[Word] = [
		Word.new('all', []),
		Word.new("your", ['wobble']),
		Word.new("base", []),
	]
	
	var sentence = SentenceScene.instantiate()
	sentence.set_words(words)
	sentence.position = Vector2(100,200)
	sentence.custom_minimum_size = Vector2(100, 50)
	add_child(sentence)
