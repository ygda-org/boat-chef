extends AudioStreamPlayer

@export var variate = false

@export var type = ""

func playSound():
	if variate == true:
		pitch_scale = 1.0 + randf_range(-0.1,0.1)
		volume_db = 0.0 + randf_range(-1.5,0)
	else:
		pitch_scale = 1.0
		volume_db = 0.0
	play()

func _process(_delta):
	if type == "music":
		volume_db = linear_to_db(GameState.music_volume * GameState.master_volume)
	elif type == "sfx":
		volume_db = linear_to_db(GameState.sfx_volume * GameState.master_volume)
	else:
		print("Audio file type not set")
		print(name)
