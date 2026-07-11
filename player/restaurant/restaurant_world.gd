extends Node2D

var boat_in_area = false

func _process(_delta):
	if boat_in_area == true:
		$Label.visible = true
	else:
		$Label.visible = false
	if boat_in_area and Input.is_action_just_pressed("interact"):
		GameState.enter_restaurant()

func _on_area_2d_body_entered(_body):
	boat_in_area = true

func _on_area_2d_body_exited(_body):
	boat_in_area = false
