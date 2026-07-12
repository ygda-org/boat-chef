extends AudioStreamPlayer2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	volume_db = linear_to_db(GameState.sfx_volume * GameState.master_volume)
	
	if GameState.sfx_volume == 0 or GameState.master_volume == 0:
		stream_paused = true
	else:
		stream_paused = false
		
