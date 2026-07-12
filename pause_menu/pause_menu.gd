extends Control

var can_unpause = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_unpause == false:
		if not Input.is_action_pressed("pause"):
			can_unpause = true
	
	if Input.is_action_just_pressed("pause") and can_unpause == true:
		get_tree().paused = false
		queue_free()
