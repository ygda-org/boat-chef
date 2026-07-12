extends Node2D

@onready var blend_sound = $Control/BlendButton/BlendSound
@onready var exit_sound = $Control/ExitDoor/ExitSound

func _ready():
	GameState.restaurant_ui = self
	disable_lid()

func _on_button_pressed():
	blend()

func blend():
	enable_lid()
	blend_sound.playSound()
	var blended = [0,0,0,0,0]
	for body in $Area2D.get_overlapping_bodies():
		blended[body.fruit_type] += 1
	GameState.check_order(blended)
	for i in range(4):
		for body in $Area2D.get_overlapping_bodies():
			if body is RigidBody2D:
				body.apply_impulse(Vector2(0,-60))
		await get_tree().create_timer(0.3).timeout
	for body in $Area2D.get_overlapping_bodies():
		body.queue_free()
	await get_tree().create_timer(0.3).timeout
	disable_lid()

func _on_exit_door_pressed():
	exit_sound.playSound()
	GameState.exit_restaurant()

func enable_lid():
	$Lid.visible = true
	$Lid/CollisionShape2D.disabled = false

func disable_lid():
	$Lid.visible = false
	$Lid/CollisionShape2D.disabled = true
