extends Node2D

func _ready():
	GameState.restaurant_ui = self

func _on_button_pressed():
	blend()

func blend():
	var blended = [0,0,0,0,0]
	for body in $Area2D.get_overlapping_bodies():
		blended[body.fruit_type] += 1
		body.queue_free()
	GameState.check_order(blended)


func _on_button_2_pressed():
	GameState.exit_restaurant()
