extends Node2D

func _on_button_pressed():
	blend()

func blend():
	var blended = [0,0,0,0,0]
	for body in $Area2D.get_overlapping_bodies():
		blended[body.fruit_type] += 1
		body.queue_free()
