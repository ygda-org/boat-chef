extends RigidBody2D

var fruit_type: int
var texture_to_set

var grabbed = false
var mouse = false

const FORCE_STRENGTH = 10000

func _ready():
	$Sprite2D.texture = texture_to_set

func _process(delta):
	if mouse and Input.is_action_just_pressed("left_click"):
		grabbed = true
	elif Input.is_action_just_released("left_click"):
		grabbed = false
	if grabbed:
		var force = FORCE_STRENGTH*(get_global_mouse_position()-global_position).normalized()*delta
		force *= (get_global_mouse_position()-global_position).length()/200
		apply_force(force)
	else:
		apply_force(Vector2(0, 100))

func _on_mouse_entered():
	mouse = true

func _on_mouse_exited():
	mouse = false
