extends Label

@onready var ding = $Ding
@onready var tick = $Tick
@onready var clink_and_slurp = $ClinkAndSlurp

var displayed_score = 0

var target_score = 0
var current_step_size = 1

func _ready():
	GameState.score_ticker = self

func add_score(amount, step_size):
	clink_and_slurp.playSound()
	target_score = target_score + amount
	current_step_size = step_size
	tick.play()

func _process(_delta):
	
	tick.volume_db = linear_to_db(GameState.sfx_volume * GameState.master_volume)
	
	displayed_score += current_step_size
	if displayed_score > target_score:
		displayed_score = target_score
	text = str(displayed_score)


func _on_audio_stream_player_finished():
	if displayed_score != target_score:
		tick.pitch_scale += 0.0005
		tick.play()
	else:
		ding.playSound()
