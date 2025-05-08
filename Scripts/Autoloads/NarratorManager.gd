extends Node

signal speak_line(text: String)
signal dialog_done()

var dialog_sets = {
	"intro": [
		"Ah. You're awake. Huh. Earlier than expected, actually.",
		"",
		"...Right. Hold on, just… give me a second.",
		"",
		"I wasn’t exactly prepared for this. I was, uh… watching a documentary. Well. Technically a YouTube compilation of ducks stealing sandwiches. Same thing, really.",
		"",
		"...Anyway.",
		"",
		"Emmet. Welcome. Glad you’re here. Truly.",
		"",
		"You’re currently located at a highly secretive… well, let's call it a research facility. That's close enough.",
		"",
		"You’ve been selected—carefully selected—to participate in a series of evaluations.",
		"",
		"Your purpose is simple: complete each test, advance to the next, demonstrate… competence.",
		"",
		"Consider it… an opportunity. A chance to prove yourself valuable. Useful. Essential, even.",
		"",
		"And at the end of it all… a reward. Yes. A very generous reward. The specifics are… pending, but trust me—it’ll be worth it.",
		"",
		"I’ll be monitoring, of course. Every step, every success, every… mistake.",
		"",
		"So. Let’s not waste any more time.",
		"",
		"Door’s unlocked. Or, well… *mostly* unlocked. Should open just enough if you, uh… squeeze a bit.",
		"",
		"Off you go, Emmet. Your test begins now."
	]
}


var dialog_queue: Array = []
var is_playing: bool = false

func say(text: String):
	dialog_queue.clear()
	dialog_queue.append(text)
	_process_queue()

func say_lines(set_or_array):
	if typeof(set_or_array) == TYPE_STRING and dialog_sets.has(set_or_array):
		dialog_queue += dialog_sets[set_or_array]
	elif typeof(set_or_array) == TYPE_ARRAY:
		dialog_queue += set_or_array
	else:
		push_error("NarratorManager: Invalid dialog set or array.")
	_process_queue()

func _process_queue():
	if is_playing or dialog_queue.is_empty():
		return
	var next_line = dialog_queue.pop_front()
	is_playing = true
	emit_signal("speak_line", next_line)

func finished_line():
	is_playing = false
	_process_queue()
	if dialog_queue.is_empty():
		emit_signal("dialog_done")
