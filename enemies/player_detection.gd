extends Area2D
@export var size: int
# this scene doesnt work anymore dont use it probably
var player_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.shape.radius = size

func _physics_process(_delta: float) -> void:
	if has_overlapping_bodies(): # Can only overlap with boat
		player_position = get_overlapping_bodies()[0].global_position
	else:
		player_position = null
