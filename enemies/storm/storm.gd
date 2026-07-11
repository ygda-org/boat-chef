extends Node2D

@onready var terrain = $"../Terrain"

var target

var speed = 100

var map_size
var tile_size = 16

# Called when the node enters the scene tree for the first time.
func _ready():
	
	map_size = GameState.terrain.size * tile_size
	
	position = Vector2(
		randf()*map_size.x,
		randf()*map_size.y
	)
	target = Vector2(
		randf()*map_size.x,
		randf()*map_size.y
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	if abs(position.x - target.x) < 10 and abs(position.y - target.y) < 10:
		target = Vector2(randf()*map_size.x,randf()*map_size.y)
	else:
		position.x = move_toward(position.x, target.x, speed * delta)
		position.y = move_toward(position.y, target.y, speed * delta)
