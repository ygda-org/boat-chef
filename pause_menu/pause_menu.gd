extends Control
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
	print(get_tree().paused)
