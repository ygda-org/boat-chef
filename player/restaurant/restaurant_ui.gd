extends Node2D

@onready var hover_button_sound = $Control/BlendButton/HoverButtonSound

@onready var blend_sound = $Control/BlendButton/BlendSound
@onready var exit_sound = $Control/ExitDoor/ExitSound

func _ready():
	GameState.restaurant_ui = self

func _on_button_pressed():
	blend()

func blend():
	blend_sound.playSound()
	var blended = [0,0,0,0,0]
	for body in $Area2D.get_overlapping_bodies():
		blended[body.fruit_type] += 1
		body.queue_free()
	GameState.check_order(blended)

func _on_exit_door_pressed():
	exit_sound.playSound()
	GameState.exit_restaurant()
