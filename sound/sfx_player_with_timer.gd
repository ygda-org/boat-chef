extends AudioStreamPlayer

@export var variate = false

@export var type = ""

@onready var timer = $Timer

@export var min = 20
@export var default = 30
@export var max = 40

func _on_timer_timeout():
	if GameState.player_disembarked != true:
		return
	playSound()
	timer.wait_time = default
	timer.wait_time = randi_range(min,max)

func playSound():
	if variate == true:
		pitch_scale = 1.0 + randf_range(-0.1,0.1)
		volume_db = 0.0 + randf_range(-1.5,0)
	else:
		pitch_scale = 1.0
		volume_db = 0.0
		
	if GameState.master_volume == 0:
		return
		
	if type == "music" and GameState.music_volume > 0:
		play()
	
	if type == "sfx" and GameState.sfx_volume > 0:
		play()
