extends Node

@onready var timer = $Timer



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameState.player_disembarked != true:
		return
	
	timer.wait_time = randi()
