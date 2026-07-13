extends RigidBody2D

@onready var fruit_grab_sound = $FruitGrabSound
@onready var fruit_release_sound = $FruitReleaseSound

var fruit_type: int
var texture_to_set

var grabbed = false
var mouse = false

const FORCE_STRENGTH = 10000

var spring_constant: float = 250
var damping_constant: float = 50

var old_velocity : Vector2 = Vector2.ZERO

func _ready():
	$Sprite2D.texture = texture_to_set
	if fruit_type == 4: #Yellow
		$Sprite2D.position = Vector2(-64.0, -68.0)
	elif fruit_type == 3: # Purple
		$Sprite2D.position = Vector2(-90.0, -120.0)
	elif fruit_type == 2: # Red
		$Sprite2D.position = Vector2(-80, -130)
	elif fruit_type == 1: # White
		$Sprite2D.position = Vector2(-90.0, -115.0)
	elif fruit_type == 0: # Eliot Color
		$Sprite2D.position = Vector2(-105.0, -115.0)
	$Sprite2D.position += Vector2(8,9)
	GameState.restaurant_ui_visible_updated.connect(_on_restaurant_ui_visible_updated)

func _process(delta):
	if not GameState.in_restaurant:
		return
	if mouse and Input.is_action_just_pressed("left_click"):
		fruit_grab_sound.playSound()
	if mouse and Input.is_action_just_released("left_click"):
		fruit_release_sound.playSound()

	if mouse and Input.is_action_just_pressed("left_click"):
		grabbed = true
	elif Input.is_action_just_released("left_click"):
		grabbed = false
	if grabbed:
		var displacement_to_mouse = get_global_mouse_position() - global_position

		var spring_force = displacement_to_mouse * spring_constant
		var damping_force = -linear_velocity * damping_constant
			
		apply_force((spring_force + damping_force) * delta)
		
	else:
		apply_force(Vector2(0, 100))
	if global_position.x < GameState.restaurant_ui.global_position.x or global_position.x > GameState.restaurant_ui.global_position.x + get_viewport_rect().size.x:
		linear_velocity = Vector2.ZERO
		global_position = get_global_mouse_position()

func _on_mouse_entered():
	mouse = true

func _on_mouse_exited():
	mouse = false

func _on_restaurant_ui_visible_updated():
	if GameState.in_restaurant:
		freeze = false
		grabbed = false
		linear_velocity = old_velocity
	else:
		old_velocity = linear_velocity
		freeze = true
		grabbed = false
