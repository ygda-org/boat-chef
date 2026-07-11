extends AudioStreamPlayer

func playSound():
	pitch_scale = 1.0 + randf_range(-0.1,0.1)
	volume_db = 0.0 + randf_range(-1.5,0)
	playing = true
