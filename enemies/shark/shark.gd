extends CharacterBody2D

var SPEED = 10000
var is_roaming: bool = false
var offset: Vector2
var killer: bool = randf() < 0.1
var stuck = 0

signal death

func _ready() -> void:
	if killer:
		offset = Vector2(0,0)
	else:
		SPEED = 12000
		offset = Vector2(randf_range(-200,200),randf_range(-200,200))
	
	if move_and_collide(Vector2.ZERO, true):
		death.emit()
		queue_free()

func _physics_process(delta: float) -> void:
	$DeathTimer.stop()
	
	if global_position.distance_to(GameState.boat.global_position + offset) < 50:
		offset = Vector2(randf_range(-200,200),randf_range(-200,200))
	
	if get_real_velocity().length() < 50:
		stuck += delta
	else:
		stuck = 0
	if stuck >= 5:
		death.emit()
		queue_free()
	
	var dir
	if GameState.boat.player_disembarked:
		dir = global_position.direction_to(GameState.boat.global_position) * -1
	else:
		$RayCast2D.target_position = GameState.boat.global_position - global_position
		if $RayCast2D.get_collider() is CharacterBody2D and $RayCast2D.get_collider().get_collision_layer_value(3):
				dir = global_position.direction_to(GameState.boat.global_position + offset)
		else:
			dir = global_position.direction_to(GameState.boat.global_position + Vector2(randf_range(-75,75),randf_range(-75,75)))
	velocity = dir * SPEED * delta
	var angle = fmod(rad_to_deg(velocity.angle()) + 360, 360)
	angle /= 45
	angle = roundi(angle) % 8
	$AnimatedSprite2D.play(str(angle))
	
	move_and_slide()

func _on_death_timer_timeout() -> void:
	death.emit()
	queue_free()


func _on_randomness_timer_timeout() -> void:
	if killer:
		return
	else:
		offset = Vector2(randf_range(-200,200),randf_range(-200,200))
