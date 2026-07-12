extends Node2D

@onready var juice_sound = $Control/BlendButton/JuiceSound
@onready var blend_sound = $Control/BlendButton/BlendSound
@onready var exit_sound = $Control/ExitDoor/ExitSound
@onready var blender_top_on_sound = $BlenderTopOnSound
@onready var blender_top_off_sound = $BlenderTopOffSound

func _ready():
	GameState.restaurant_ui = self
	disable_lid()

func _on_button_pressed():
	blend()

func blend():
	blender_top_on_sound.playSound()
	enable_lid()
	await blender_top_on_sound.finished
	blend_sound.playSound()
	juice_sound.playSound()
	var blended = [0,0,0,0,0]
	var rigid_body_list : Array[RigidBody2D]
	for body in $Area2D.get_overlapping_bodies():
		blended[body.fruit_type] += 1
		if body is RigidBody2D:
			rigid_body_list.append(body)
	#Blender Gradient
	var order_ticket : OrderTicket = OrderTicket.new()
	var gradient_colors : Array[Color] = order_ticket.get_gradient_colors(blended)
	
	$Lid/Fill_Max.texture.gradient = Gradient.new()
	$Lid/Fill_Max.texture.gradient.set_color(0, gradient_colors[0])
	$Lid/Fill_Max.texture.gradient.set_color(1, gradient_colors[1])
	
	var tween = get_tree().create_tween()
	tween.tween_property($Lid/Fill_Max, "self_modulate", Color(1.0,1.0,1.0,1.0), 1.2).set_trans(Tween.TRANS_SINE)
	
	GameState.check_order(blended)
	for i in range(8):
		for body in rigid_body_list:
			body.collision_layer = 0
			body.apply_impulse(Vector2(randf_range(60,75) * ((randi() % 2) * 2 - 1),-randi_range(25,35)))
		await get_tree().create_timer(0.15).timeout
	for body in rigid_body_list:
		body.queue_free()
	await get_tree().create_timer(0.3).timeout
	disable_lid()
	blender_top_off_sound.playSound()
	
	$Lid/Fill_Max.self_modulate = Color(1.0,1.0,1.0,0.0)

func _on_exit_door_pressed():
	exit_sound.playSound()
	GameState.exit_restaurant()

func enable_lid():
	$Lid.visible = true
	$Lid/CollisionShape2D.disabled = false

func disable_lid():
	$Lid.visible = false
	$Lid/CollisionShape2D.disabled = true
