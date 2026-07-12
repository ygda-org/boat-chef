extends CharacterBody2D

const ACCELERATION = 150
const DECELERATION = 200
const MAX_SPEED = 200

const BOOST_MULTIPLIER = 1.8
const MAX_BOOST = 1.5
@onready var boost_amount = MAX_BOOST

const CAMERA_PAN_FACTOR = 1

const BUBBLES = preload("uid://di2fr5wd01t5t")

@onready var spt = $Anim
const ANIMATION_NAMES = ["right", "t_right_up", "t_right_up2", "up_right", "t_up_right2", "t_up_right",
						"up", "t_up_left", "t_up_left2", "up_left", "t_left_up2", "t_left_up",
						"left", "t_left_down", "t_left_down2", "down_left", "t_down_left2", "t_down_left",
						"down", "t_down_right", "t_down_right2", "down_right", "t_right_down2", "t_right_down"]
var goal = ""

var angle

var player_disembarked = false
var player

const PAUSE_MENU = preload("uid://dconohkodldha")

@onready var canvas_layer = $"../CanvasLayer"

@onready var boat_fast_sfx = $BoatFastSFX
@onready var boat_normal_sfx = $BoatNormalSFX

@onready var disembark_boat_sound = $DisembarkBoatSound

var old_engine_state = "none"

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
		$Smoke.emitting = false
		$FastSmoke.emitting = false
		$WaterStreamArm/WaterStream.emitting = false
		if player:
			if player.global_position.distance_to(global_position) < 70:
				$Label.visible = true
			else:
				$Label.visible = false
			$Camera2D.global_position = player.global_position
		return
	if Input.is_action_just_pressed("exit_boat"):
		player_disembark()
	if velocity.length() > 100:
		$WaterStreamArm.rotation = velocity.angle() + PI/2
		if not $WaterStreamArm/WaterStream.emitting:
			$WaterStreamArm/WaterStream.emitting = true
		$Foam.visible = true
	else:
		$WaterStreamArm/WaterStream.emitting = false
		$Foam.visible = false
	if Input.is_action_pressed("zoom_out"):
		$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(0.8,0.8), delta*2)
		velocity = velocity.move_toward(Vector2(0,0), DECELERATION * delta)
		move_and_slide()
		return
	var calc_max_speed
	if $BounceTimer.is_stopped():
		calc_max_speed = MAX_SPEED
	else:
		calc_max_speed = MAX_SPEED * 1000
	var calc_acceleration = ACCELERATION
	
	var dir
	if $BounceTimer.is_stopped():
		dir = Input.get_vector("left", "right", "up", "down")
	else:
		dir = Vector2.ZERO
	
	var boosted = Input.is_action_pressed("boost") and boost_amount >= 0 and dir and $BounceTimer.is_stopped()
	if boosted:
		if not $Smoke.emitting:
			$Smoke.emitting = true
			$FastSmoke.emitting = false
		boost_amount -= delta
		calc_max_speed *= BOOST_MULTIPLIER
		calc_acceleration *= BOOST_MULTIPLIER
		
	else:
		if not $FastSmoke.emitting:
			$Smoke.emitting = false
			$FastSmoke.emitting = true
		boost_amount = clampf(boost_amount + delta/2, -1, MAX_BOOST)
	
	if boosted:
		play_engine_sound("boost")
	elif velocity.length() > 0 and $BounceTimer.is_stopped():
		play_engine_sound("normal")
	else:
		play_engine_sound("none")
	
	#var zoom_amount = 300/velocity.length() + 1.0
	var zoom_amount = 2.5 * 0.999**velocity.length()
	zoom_amount = clampf(zoom_amount, 1.0, 2.5)
	$Camera2D.zoom = $Camera2D.zoom.lerp(Vector2(zoom_amount, zoom_amount), delta)
	$BoostBar.value = boost_amount
	
	if not dir:
		$Smoke.emitting = false
		$FastSmoke.emitting = false
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
		goal = "right"
	elif angle == 1:
		goal = "down_right"
	elif angle == 2:
		goal = "down"
	elif angle == 3:
		goal = "down_left"
	elif angle == 4 or angle == -4:
		goal = "left"
	elif angle == -1:
		goal = "up_right"
	elif angle == -2:
		goal = "up"
	elif angle == -3:
		goal = "up_left"
	if not dir:
		goal = "none"
	if goal != spt.animation and $TurnTimer.is_stopped():
		$TurnTimer.start()
	
	move_and_slide()
	GameState.player_position = global_position

func player_disembark():
	GameState.player_disembarked = true
	disembark_boat_sound.playSound()
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
	GameState.player_disembarked = false
	disembark_boat_sound.playSound()
	player_disembarked = false
	$Label.visible = false
	velocity = Vector2(0, 0)

func _on_boat_particle_timer_timeout() -> void:
	if velocity.length() > 100 and not player_disembarked:
		var bubbles = BUBBLES.instantiate()
		get_parent().add_child(bubbles)
		bubbles.global_position = $WaterStreamArm/Marker2D.global_position
		bubbles.rotation = velocity.angle()
		bubbles.emitting = true

func _on_turn_timer_timeout():
	if goal == "none":
		return
	var goal_ind = ANIMATION_NAMES.find(goal)
	var current_ind = ANIMATION_NAMES.find(spt.animation)
	if goal_ind == current_ind:
		return
	var dist_up 
	var dist_down
	for i in range(25):
		if (current_ind + i) % 24 == goal_ind:
			dist_up = i
		if posmod(current_ind - i, 24) == goal_ind:
			dist_down = i
	var direction = int(dist_up < dist_down or dist_up == 12) * 2 - 1
	spt.play(ANIMATION_NAMES[(current_ind+direction)%24])
	current_ind = ANIMATION_NAMES.find(spt.animation)
	var foam_animation = spt.animation
	if current_ind > 0 and current_ind < 7:
		$Foam.flip_h = false
		$Foam.flip_v = false
	elif current_ind > 6 and current_ind < 13: # flip lr
		$Foam.flip_h = true
		$Foam.flip_v = false
	elif current_ind > 12 and current_ind < 19: # flip both
		foam_animation = foam_animation.replace("down", "up")
		$Foam.flip_h = true
		$Foam.flip_v = true
	elif current_ind > 18 and current_ind < 24: # flip ud
		foam_animation = foam_animation.replace("left", "right")
		foam_animation = foam_animation.replace("down", "up")
		$Foam.flip_h = false
		$Foam.flip_v = true
	if current_ind > 2 and current_ind < 10:
		foam_animation = foam_animation.replace("left", "right")
	elif current_ind > 9 and current_ind < 18:
		foam_animation = foam_animation.replace("left", "right")
		foam_animation = foam_animation.replace("down", "up")
	elif current_ind > 15 and current_ind < 22:
		foam_animation = foam_animation.replace("down", "up")
	if foam_animation == "right":
		foam_animation = "up"
		$Foam.rotation = PI/2
		$Foam.flip_h = false
		if current_ind == 12:
			$Foam.flip_v = true
	else:
		$Foam.rotation = 0
	$Foam.play(foam_animation)


func play_engine_sound(state):
	if state == old_engine_state:
		return
	
	boat_fast_sfx.stop()
	boat_normal_sfx.stop()
	
	if state == "boost":
		boat_fast_sfx.playSound()
	elif state == "normal":
		boat_normal_sfx.playSound()
		
	old_engine_state = state
