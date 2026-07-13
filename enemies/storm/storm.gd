extends Node2D

@onready var terrain = GameState.terrain

const TARGET_DISTANCE_MARGIN = 100

var target

const ACCELERATION = 40
const MAX_SPEED = 100
var velocity = Vector2(0,0)

var map_size
var tile_size = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	
	map_size = (GameState.terrain.size * tile_size) / 2

	_on_target_timer_timeout()


func _process(delta):
	if global_position.distance_to(target) < TARGET_DISTANCE_MARGIN:
		get_new_target()
	velocity = velocity.move_toward(target-global_position, delta*ACCELERATION)
	velocity = velocity.limit_length(MAX_SPEED)
	position += velocity * delta
	#print(global_position)

func get_new_target():
	$TargetTimer.start()

func _on_target_timer_timeout() -> void:
	target = GameState.tree_pos.pick_random().global_position


func _on_life_timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(0.0, 0.0, 0.0, 0.0), 1)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered():
	$ThickRain.emitting = true
	visible = true


func _on_visible_on_screen_notifier_2d_screen_exited():
	$ThickRain.emitting = false
	visible = false
