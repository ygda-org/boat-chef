extends CharacterBody2D

const ACCELERATION = 150
const DECELERATION = 200
const MAX_SPEED = 200

const CAMERA_ZOOM_FACTOR = 1

const ROTATE_SPEED = 0.8
var sprite_rotation: float = 0.0
var target_rotation: float = 0.0

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
	target_rotation = velocity.angle()
	sprite_rotation = lerp_angle(sprite_rotation, target_rotation, 1 - pow(delta, 1 - ROTATE_SPEED))
	
	# make logic for picking which frame to draw from sprite rotation
	# maybe rework velocity system to make it based off rotation like tank controls? idk
	
	move_and_slide()
