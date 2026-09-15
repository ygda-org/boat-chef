extends VisibleOnScreenNotifier2D

var FISH = preload("uid://yp8f47mtjl5")
const FISH_MIN = 3
const FISH_MAX = 12
const SPAWN_CIRCLE_RADIUS = 70

func _on_screen_entered():
	for i in range(randi_range(FISH_MIN, FISH_MAX)):
		var fish: Node2D = FISH.instantiate()
		call_deferred("add_child", fish)
		fish.position.x = randf_range(1, SPAWN_CIRCLE_RADIUS)
		fish.position = fish.position.rotated(randf_range(0, 2*PI))


func _on_screen_exited():
	for node in get_children():
		node.queue_free()
