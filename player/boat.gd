extends CharacterBody2D

const ACCELERATION = 150
const DECELERATION = 200
const MAX_SPEED = 200

const BOOST_MULTIPLIER = 1.5
const MAX_BOOST = 1.5
@onready var boost_amount = MAX_BOOST

const CAMERA_PAN_FACTOR = 1

@onready var sprite_2d = $Sprite2D

var angle

func _ready():
	$BoostBar.max_value = MAX_BOOST
	$BoostBar.value = boost_amount

func _physics_process(delta):
	var calc_max_speed = MAX_SPEED
	var calc_acceleration = ACCELERATION
	if Input.is_action_pressed("boost") and boost_amount >= 0:
		boost_amount -= delta
		$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(1.8,1.8), delta)
		calc_max_speed *= BOOST_MULTIPLIER
		calc_acceleration *= BOOST_MULTIPLIER
	else:
		boost_amount = clampf(boost_amount + delta/2, -1, MAX_BOOST)
		$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(2,2), delta)
	$BoostBar.value = boost_amount
	var dir = Input.get_vector("left", "right", "up", "down")
	if dir.x:
		velocity.x = clampf(velocity.x + dir.x * calc_acceleration * delta, -calc_max_speed, calc_max_speed)
		if dir.x * velocity.x < 0:
			velocity.x += DECELERATION * delta * dir.x
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	if dir.y:
		velocity.y = clampf(velocity.y + dir.y * calc_acceleration * delta, -calc_max_speed, calc_max_speed)
		if dir.y * velocity.y < 0:
			velocity.y += DECELERATION * delta * dir.y
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATION * delta)
	velocity = velocity.limit_length(calc_max_speed)
	$Camera2D.position = velocity * CAMERA_PAN_FACTOR
	
	# make logic for picking which frame to draw from sprite rotation
	# maybe rework velocity system to make it based off rotation like tank controls? idk
	
	angle = rad_to_deg(dir.angle())
	angle /= 45
	angle = round(angle)
	if angle == 0:
		sprite_2d.rotation = deg_to_rad(90)
	elif angle == 1:
		sprite_2d.rotation = deg_to_rad(135)
	elif angle == 2:
		sprite_2d.rotation = deg_to_rad(180)
	elif angle == 3:
		sprite_2d.rotation = deg_to_rad(225)
	elif angle == 4 or angle == -4:
		sprite_2d.rotation = deg_to_rad(270)
	elif angle == -1:
		sprite_2d.rotation = deg_to_rad(45)
	elif angle == -2:
		sprite_2d.rotation = deg_to_rad(0)
	elif angle == -3:
		sprite_2d.rotation = deg_to_rad(315)
	
	move_and_slide()
