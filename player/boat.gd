extends CharacterBody2D

const ACCELERATION = 150
const DECELERATION = 250
const MAX_SPEED = 200

const CAMERA_ZOOM_DISTANCE = 150

const ROTATE_SPEED = 0.8
var sprite_rotation: float = 0.0
var target_rotation: float = 0.0

func _physics_process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	$Camera2D.position = dir * CAMERA_ZOOM_DISTANCE
	if dir:
		velocity = (velocity + dir * ACCELERATION * delta).limit_length(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
	target_rotation = velocity.angle()
	sprite_rotation = lerp_angle(sprite_rotation, target_rotation, 1 - pow(delta, 1 - ROTATE_SPEED))
	
	# make logic for picking which frame to draw from sprite rotation
	# maybe rework velocity system to make it based off rotation like tank controls? idk
	
	move_and_slide()
