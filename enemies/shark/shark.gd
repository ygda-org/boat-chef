extends CharacterBody2D

const SPEED = 7500
var is_roaming: bool = false

signal death

func _ready() -> void:
	if move_and_collide(Vector2.ZERO, true):
		death.emit()
		queue_free()

func _physics_process(delta: float) -> void:
	$DeathTimer.stop()
	var dir
	if GameState.boat.player_disembarked:
		dir = global_position.direction_to(GameState.boat.global_position) * -1
	else:
		$RayCast2D.target_position = GameState.boat.global_position - global_position
		if $RayCast2D.get_collider() is CharacterBody2D and $RayCast2D.get_collider().get_collision_layer_value(3):
				dir = global_position.direction_to(GameState.boat.global_position)
				
		else:
			velocity = Vector2.ZERO
			return
	velocity = dir * SPEED * delta
	var angle = fmod(rad_to_deg(velocity.angle()) + 360, 360)
	angle /= 45
	angle = roundi(angle) % 8
	$AnimatedSprite2D.play(str(angle))
	
	move_and_slide()

func _on_death_timer_timeout() -> void:
	death.emit()
	queue_free()
