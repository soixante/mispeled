extends Node

func scramble(s: String) -> String:
	var words: Array = s.split(" ")
	var newWords: Array = []
	for word in words:
		if word.length() <= 3:
			newWords.push_back(word)
			continue
		var chars = word.split("")
		var first = chars[0]
		var last = chars[chars.size() - 1]
		var middle: Array = chars.slice(1, chars.size() - 1)

		middle.shuffle()
		newWords.push_back(first + String("".join(middle)) + last)
	
	return String(" ".join(newWords))
