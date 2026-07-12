extends Label

var displayed_score

var target_score
var current_step_size

func add_score(amount, step_size):
	target_score = target_score + amount
	current_step_size = step_size

func _process(_delta):
	displayed_score += current_step_size
	
