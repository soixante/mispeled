extends RichTextLabel

class_name Sentence

var words: Array[Word] = []
var cooked: String = ''
var raw: String = ''
var capture = true
var ttl = 0

func _ready() -> void:
	add_to_group('sentences')
	
func set_words(initWords: Array[Word]) -> void:
	words = initWords
	var first = true
	for word in words:
		if first:
			first = false
		else:
			word.word = " " + word.word

	for word in words:
		raw += word.word
		cooked += word.cook()
	
	raw = raw.strip_edges()
	cooked = cooked.strip_edges()

	text = cooked
	
func validate(buffer: String) -> bool:
	if !capture:
		return false
		
	var to_match = raw

	if (buffer.ends_with(to_match)):
		highlight_sentence(to_match.length())
		SignalsHandler.sentence_typed.emit(self)
		capture = false
		return true
	#
	var incomplete_matched := 0
	for i in range(to_match.length() -1 , 0, -1):
		var incomplete_match = to_match.substr(0, i);
		if (buffer.ends_with(incomplete_match)):
			incomplete_matched = incomplete_match.length()
			break

	highlight_sentence(incomplete_matched)
	return false
	

func highlight_sentence(len: int) -> void:
	if len <= 0:
		text = cooked
		return
	
	var highlighted = ""
	var remaining_chars = len
	var first = true
	
	for word in words:
		var word_len = word.word.length()
		
		if remaining_chars >= word_len:
			highlighted += word.cook_highlight(word_len)
			remaining_chars -= word_len
		elif remaining_chars > 0:
			highlighted += word.cook_highlight(remaining_chars)
			remaining_chars = 0
		else:
			highlighted += word.cook()
			
	text = highlighted.strip_edges()
