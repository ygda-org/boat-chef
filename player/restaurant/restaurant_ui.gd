extends Node2D

@onready var sfx_player = $Control/BlendButton/SfxPlayer

func _ready():
	GameState.restaurant_ui = self

func _on_button_pressed():
	blend()

func blend():
	sfx_player.playSound()
	var blended = [0,0,0,0,0]
	for body in $Area2D.get_overlapping_bodies():
		blended[body.fruit_type] += 1
		body.queue_free()
	GameState.check_order(blended)


func _on_exit_door_pressed():
	GameState.exit_restaurant()
