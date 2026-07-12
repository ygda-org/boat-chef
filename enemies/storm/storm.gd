extends Node2D

@onready var terrain = GameState.terrain

const TARGET_DISTANCE_MARGIN = 100

var target

const ACCELERATION = 40
const MAX_SPEED = 150
var velocity = Vector2(0,0)

var map_size
var tile_size = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	
	map_size = GameState.terrain.size * tile_size
	
	position = Vector2(0,0)
	#position = Vector2(
		#randf()*map_size.x,
		#randf()*map_size.y
	#)
	target = get_new_target()


func _process(delta):
	if global_position.distance_to(target) < TARGET_DISTANCE_MARGIN:
		target = get_new_target()
	velocity = velocity.move_toward(target-global_position, delta*ACCELERATION)
	velocity.limit_length(MAX_SPEED)
	position += velocity * delta

func get_new_target():
	return Vector2(randf()*map_size.x,randf()*map_size.y)
