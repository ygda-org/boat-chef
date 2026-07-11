extends Node2D

const PICK_UP_FRUIT = preload("uid://de8qg8j7lpgiu")

const DEEP_WATER = Vector2i(5,1)
const SHALLOW_WATER = Vector2i(7,0)
const SAND = Vector2i(3,0)
const GRASS = Vector2i(3,3)

@export var altitude : FastNoiseLite

var size : Vector2i = Vector2i(300,300)

@onready var tilemap := $TileMapLayer

func _ready() -> void:
	GameState.terrain = self
	randomize_noise(randi())
	generate_terrain()

func randomize_noise(seed : int):
	altitude.seed = seed

func clear_decor():
	for c in $Decor.get_children():
		c.queue_free()

func generate_terrain():
	for x : int in range(-size.x/2, size.x/2):
		for y : int in range(-size.y/2, size.y/2):
			var noise := altitude.get_noise_2d(x, y)
			noise = (noise + 1)/2.0 # maps noise to [0, 1]
			# high = grass
			# low = water
			var distance_to_closest_island = Vector2i(x, y).distance_to(Vector2.ZERO)
			if distance_to_closest_island < 20:
				noise += 1 - distance_to_closest_island / 10.0
				
			var atlas : Vector2i
			if noise < 0.4: # deep water
				atlas = DEEP_WATER
			elif noise < 0.7: # shallow water
				atlas = SHALLOW_WATER
			elif noise < 0.75: # sand
				atlas = SAND
			else:
				atlas = GRASS
				if randf() < 0.1:
					var p = PICK_UP_FRUIT.instantiate()
					$Decor.add_child(p)
					p.position = Vector2(x * 16,y * 16)
			
			tilemap.set_cell(Vector2(x,y), 0, atlas)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		randomize_noise(randi())
		clear_decor()
		generate_terrain()
