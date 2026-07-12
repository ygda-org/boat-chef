extends Label

var displayed_score = 0

var target_score = 0
var current_step_size = 1

func _ready():
	GameState.score_ticker = self

func add_score(amount, step_size):
	target_score = target_score + amount
	current_step_size = step_size
	$AudioStreamPlayer.play()

func _process(_delta):
	
	$AudioStreamPlayer.volume_db = linear_to_db(GameState.sfx_volume * GameState.master_volume)
	
	displayed_score += current_step_size
	if displayed_score > target_score:
		displayed_score = target_score
	text = str(displayed_score)


func _on_audio_stream_player_finished():
	if displayed_score != target_score:
		$AudioStreamPlayer.pitch_scale += 0.0005
		$AudioStreamPlayer.play()
