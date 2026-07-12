extends Node2D

@onready var terrain = GameState.terrain

const TARGET_DISTANCE_MARGIN = 100

var target

const ACCELERATION = 40
const MAX_SPEED = 30
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
	velocity.limit_length(MAX_SPEED)
	position += velocity * delta

func get_new_target():
	$TargetTimer.start()

func _on_target_timer_timeout() -> void:
	target = Vector2(randf_range(-map_size.x, map_size.x),randf_range(-map_size.y, map_size.y))
