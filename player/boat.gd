extends CharacterBody2D

const ACCELERATION = 150
const DECELERATION = 200
const MAX_SPEED = 200

const CAMERA_ZOOM_FACTOR = 1

@onready var sprite_2d = $Sprite2D

var angle

func _physics_process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	if dir.x:
		velocity.x = clampf(velocity.x + dir.x * ACCELERATION * delta, -MAX_SPEED, MAX_SPEED)
		if dir.x * velocity.x < 0:
			velocity.x += DECELERATION * delta * dir.x
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	if dir.y:
		velocity.y = clampf(velocity.y + dir.y * ACCELERATION * delta, -MAX_SPEED, MAX_SPEED)
		if dir.y * velocity.y < 0:
			velocity.y += DECELERATION * delta * dir.y
	else:
		velocity.y = move_toward(velocity.y, 0, DECELERATION * delta)
	velocity = velocity.limit_length(MAX_SPEED)
	$Camera2D.position = velocity * CAMERA_ZOOM_FACTOR
	
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
