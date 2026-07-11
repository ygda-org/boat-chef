extends CharacterBody2D

const SPEED = 5000
var is_roaming: bool = false

func _physics_process(delta: float) -> void:
	is_roaming = $PlayerDetection.player_position == null
	if is_roaming:
		velocity = Vector2.ZERO
	else:
		$RayCast2D.target_position = $PlayerDetection.player_position - global_position
		if $RayCast2D.get_collider() is CharacterBody2D and $RayCast2D.get_collider().get_collision_layer_value(3):
				var dir = global_position.direction_to($PlayerDetection.player_position)
				velocity = dir * SPEED * delta
		else:
			velocity = Vector2.ZERO
	move_and_slide()
		
# raycast and player detection is redundant, unless we add pathfinding
