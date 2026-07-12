extends CharacterBody2D

const ACCELERATION = 150
const DECELERATION = 200
const MAX_SPEED = 200

const BOOST_MULTIPLIER = 1.8
const MAX_BOOST = 1.5
@onready var boost_amount = MAX_BOOST

const CAMERA_PAN_FACTOR = 1

const BUBBLES = preload("uid://di2fr5wd01t5t")

@onready var sprite_2d = $Sprite2D

var angle

var player_disembarked = false
var player

func _ready():
	GameState.boat = self
	$BoostBar.max_value = MAX_BOOST
	$BoostBar.value = boost_amount
	$Camera2D.limit_left = GameState.size.x / -2 * 16 + 8
	$Camera2D.limit_right = GameState.size.x / 2 * 16 - 8
	$Camera2D.limit_top = GameState.size.y / -2 * 16 + 8
	$Camera2D.limit_bottom = GameState.size.y / 2 * 16 - 8

func _physics_process(delta):
	if GameState.in_restaurant:
		return
	if player_disembarked: # camera follow player
		if player:
			if player.global_position.distance_to(global_position) < 70:
				$Label.visible = true
			else:
				$Label.visible = false
			$Camera2D.global_position = player.global_position
		return
	if Input.is_action_just_pressed("exit_boat"):
		player_disembark()
	if Input.is_action_pressed("zoom_out"):
		$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(0.8,0.8), delta*2)
		velocity = velocity.move_toward(Vector2(0,0), DECELERATION * delta)
		move_and_slide()
		return
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

func player_disembark():
	var raycast: RayCast2D = $PlayerSpawnFinder
	for i in range(8):
		if raycast.is_colliding():
			player = load("uid://rw44bs7ullm0").instantiate()
			player.boat = self
			player.global_position = raycast.get_collision_point() + global_position.direction_to(raycast.get_collision_point()) * 20
			get_parent().add_child(player)
			player_disembarked = true
			break
		else:
			raycast.target_position = raycast.target_position.rotated(i*PI/4)
			raycast.force_raycast_update()

func embark():
	player_disembarked = false
	$Label.visible = false
	velocity = Vector2(0, 0)

func _on_boat_particle_timer_timeout() -> void:
	if velocity.length() > 100 and not player_disembarked:
		var bubbles = BUBBLES.instantiate()
		get_parent().add_child(bubbles)
		bubbles.global_position = $Sprite2D/Marker2D.global_position
		bubbles.rotation = sprite_2d.rotation
		bubbles.emitting = true
