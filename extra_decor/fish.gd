extends Area2D

var velocity = Vector2(0,0)

func _ready():
	rotation = randi_range(0,3) * PI/2

func _process(delta):
	if velocity:
		position += velocity * delta

func _on_body_entered(body):
	if velocity:
		return
	velocity = (global_position.direction_to(body.global_position)).orthogonal().rotated(randf_range(-PI/4, PI/4)) * 150 * (randi_range(0,1)*2-1)
	look_at(global_position + velocity)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1)
	tween.tween_callback(queue_free)
