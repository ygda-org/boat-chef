extends RigidBody2D

var fruit_type: int
var texture_to_set

var grabbed = false
var mouse = false

const FORCE_STRENGTH = 10000

var spring_constant: float = 33
var damping_constant: float = 5

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
		
		var displacement_to_mouse = get_global_mouse_position() - global_position

		var spring_force = displacement_to_mouse * spring_constant
		var damping_force = -linear_velocity * damping_constant
			
		apply_force(spring_force + damping_force)
		
	else:
		apply_force(Vector2(0, 100))

func _on_mouse_entered():
	mouse = true

func _on_mouse_exited():
	mouse = false
