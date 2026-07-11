extends CharacterBody2D

const ACCELERATION = 150
const DECELERATION = 250
const MAX_SPEED = 200

const CAMERA_ZOOM_DISTANCE = 150


func _physics_process(delta):
	var dir = Input.get_vector("left", "right", "up", "down")
	$Camera2D.position = dir * CAMERA_ZOOM_DISTANCE
	if dir:
		velocity = (velocity + dir * ACCELERATION * delta).limit_length(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, DECELERATION * delta)
	move_and_slide()
