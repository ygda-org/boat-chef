extends RigidBody2D

var grabbed = false
var mouse = false

const FORCE_STRENGTH = 10000

func _process(delta):
	if mouse and Input.is_action_just_pressed("left_click"):
		grabbed = true
	elif Input.is_action_just_released("left_click"):
		grabbed = false
	if grabbed:
		var force = FORCE_STRENGTH*(get_global_mouse_position()-global_position).normalized()*delta
		if force.y < 0:
			force.y *= 2
		apply_force(force)

func _on_mouse_entered():
	mouse = true

func _on_mouse_exited():
	mouse = false
