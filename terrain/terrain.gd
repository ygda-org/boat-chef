extends Node2D

#const PLANT = preload("uid://drl6ydjryc0mk")

@export var altitude : FastNoiseLite

var size : Vector2i = Vector2i(100,100)

@onready var tilemap := $TileMapLayer

# Called when the node enters the scene tree for the first time.
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
	const DEEP_WATER = Vector2i(5,1)
	const SHALLOW_WATER = Vector2i(7,0)
	const SAND = Vector2i(3,0)
	const GRASS = Vector2i(3,3)
	var origin: Vector2 = size / 2.0
	for x : int in range(size.x):
		for y : int in range(size.y):
			var noise := altitude.get_noise_2d(x, y)
			noise = (noise + 1)/2.0 # maps noise to [0, 1]
			# high = grass
			# low = water
			var distance_to_closest_island = Vector2i(x, y).distance_to(origin)
			if distance_to_closest_island < 20:
				noise += 1 - distance_to_closest_island / 10.0
				
			var atlas : Vector2i
			if noise < 0.4: # deep water
				atlas = DEEP_WATER
			elif noise < 0.7: # shallow water
				atlas = SHALLOW_WATER
			elif noise < 0.75: # sand
				atlas = SAND
				#if randf() < 0.1:
					#var p = PLANT.instantiate()
					#$Decor.add_child(p)
					#p.position = Vector2(x * 16,y * 16)
			else:
				atlas = GRASS
			
			tilemap.set_cell(Vector2(x,y), 0, atlas)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		randomize_noise(randi())
		clear_decor()
		generate_terrain()
