extends CharacterBody2D

const SPEED = 200
var is_roaming: bool = false
var offset: Vector2

signal death

func _ready() -> void:
	offset = Vector2(randf_range(-150,150),randf_range(-150,150))
	
	if move_and_collide(Vector2.ZERO, true):
		death.emit()
		queue_free()

func _physics_process(delta: float) -> void:
	if global_position.distance_to(GameState.player_position) > 1000:
		if $DeathTimer.is_stopped():
			$DeathTimer.start()
	else:
		$DeathTimer.stop()
	
	
	if global_position.distance_to(GameState.boat.global_position) < 50:
		offset = Vector2.ZERO
	elif global_position.distance_to(GameState.boat.global_position + offset) < 200:
		if global_position.distance_to(GameState.boat.global_position + offset) < 50:
			$OffsetCooldown.stop()
		generate_offset()
	var dir
	if GameState.boat.player_disembarked or not $RetreatTimer.is_stopped():
		dir = global_position.direction_to(GameState.boat.global_position) * -1
	else:
		$RayCast2D.target_position = GameState.boat.global_position - global_position
		if $RayCast2D.get_collider() is CharacterBody2D and $RayCast2D.get_collider().get_collision_layer_value(3):
			dir = global_position.direction_to(GameState.boat.global_position + offset)
		else:
			dir = global_position.direction_to(GameState.boat.global_position + Vector2(randf_range(-75,75),randf_range(-75,75)))
	velocity = dir * SPEED
	var angle = fmod(rad_to_deg(velocity.angle()) + 360, 360)
	angle /= 45
	angle = roundi(angle) % 8
	if $SpriteChangeCooldown.is_stopped() and $AnimatedSprite2D.animation != str(angle):
		$SpriteChangeCooldown.start()
		$AnimatedSprite2D.play(str(angle))
	
	var collision = move_and_collide(velocity * delta, true)
	move_and_slide()
	
	if collision and collision.get_collider() == GameState.boat and not GameState.boat.player_disembarked:
		GameState.boat.velocity = velocity * 2
		GameState.boat.get_node("BounceTimer").start()
		$RetreatTimer.start()

func _on_death_timer_timeout() -> void:
	death.emit()
	queue_free()


func _on_randomness_timer_timeout() -> void:
	generate_offset()

func generate_offset() -> void:
	if not $OffsetCooldown.is_stopped():
		return
	$OffsetCooldown.start()
	for i in range(1000):
		var new_offset = Vector2(randf_range(0,150),randf_range(0,150))
		if offset.x > 0 and new_offset.x > 0:
			new_offset.x *= -1
		if offset.y > 0 and new_offset.y > 0:
			new_offset.y *= -1
		if new_offset.distance_to(offset) > 150:
			offset = new_offset
