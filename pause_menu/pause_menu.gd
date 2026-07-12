extends Control
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	show()
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = false
		hide()
