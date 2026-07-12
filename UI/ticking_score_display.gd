extends Label

var displayed_score = 0

var target_score = 0
var current_step_size = 1

func _ready():
	GameState.score_ticker = self

func add_score(amount, step_size):
	target_score = target_score + amount
	current_step_size = step_size

func _process(_delta):
	displayed_score += current_step_size
	if displayed_score > target_score:
		displayed_score = target_score
	text = str(displayed_score)
	
