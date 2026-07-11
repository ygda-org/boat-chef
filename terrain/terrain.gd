extends Node2D

const PICK_UP_FRUIT = preload("uid://de8qg8j7lpgiu")

const DEEP_WATER = Vector2i(5,1)
const SHALLOW_WATER = Vector2i(7,0)
const SAND = Vector2i(3,0)
const GRASS = Vector2i(3,3)

@export var altitude : FastNoiseLite

var size : Vector2i = Vector2i(300,300)

@onready var tileID := $TileIDLayer
@onready var corner_tile := $CornerTileLayer

func _ready() -> void:
	GameState.terrain = self
	randomize_noise(randi())
	generate_terrain()

func randomize_noise(seed : int):
	altitude.seed = seed

func clear_decor():
	for c in $Decor.get_children():
		c.queue_free()

func set_terrain_id():
	for y : int in range(-size.y/2, size.y/2):
		for x : int in range(-size.x/2, size.x/2):
			var noise := altitude.get_noise_2d(x, y)
			noise = (noise + 1)/2.0 # maps noise to [0, 1]
			# high = grass
			# low = water
			var distance_to_closest_island = Vector2i(x, y).distance_to(Vector2.ZERO)
			if distance_to_closest_island < 20:
				noise = 0.6
				
			var atlas : Vector2i
			if noise < 0.4: # deep water
				atlas = DEEP_WATER
			elif noise < 0.67: # shallow water
				atlas = SHALLOW_WATER
			elif noise < 0.72: # sand
				atlas = SAND
			else:
				atlas = GRASS
				if randf() < 0.05:
					var p = PICK_UP_FRUIT.instantiate()
					$Decor.add_child(p)
					p.position = Vector2(x * 16,y * 16)
			
			tileID.set_cell(Vector2(x,y), 0, atlas)

## Prevent Grass touching ocean and sand touching deep ocean
func fix_terrain_id():
	var neighbors : Array[Vector2i] = [
		Vector2i.DOWN,
		Vector2i.UP,
		Vector2i.LEFT,
		Vector2i.RIGHT,
		Vector2i(1,1),
		Vector2i(-1,1),
		Vector2i(1,-1),
		Vector2i(-1,-1),
	]
	for y : int in range(-size.y/2, size.y/2):
		for x : int in range(-size.x/2, size.x/2):
			var cur_cord : Vector2i = Vector2i(x,y)
			var atlas : Vector2i = tileID.get_cell_atlas_coords(cur_cord)
			if atlas == DEEP_WATER or atlas == SHALLOW_WATER:
				continue
			for n : Vector2i in neighbors:
				var neighbor_atlas : Vector2i = tileID.get_cell_atlas_coords(cur_cord + n)
				if atlas == SAND and neighbor_atlas == DEEP_WATER:
					tileID.set_cell(cur_cord + n, 0, SHALLOW_WATER)
					break
				if atlas == GRASS and neighbor_atlas == SHALLOW_WATER:
					tileID.set_cell(cur_cord + n, 0, SAND)
					break

func set_corner_terrain():
	for y : int in range(-size.y/2, size.y/2):
		for x : int in range(-size.x/2, size.x/2):
			var cur_cord : Vector2i = Vector2i(x,y)
			#AB
			#CD
			var tile_a : Vector2i = tileID.get_cell_atlas_coords(cur_cord + Vector2i(0,0))
			var tile_b : Vector2i = tileID.get_cell_atlas_coords(cur_cord + Vector2i(1,0))
			var tile_c : Vector2i = tileID.get_cell_atlas_coords(cur_cord + Vector2i(0,1))
			var tile_d : Vector2i = tileID.get_cell_atlas_coords(cur_cord + Vector2i(1,1))
			var corners : Array[Vector2i] = [tile_a, tile_b, tile_c, tile_d]
			
			var base : Vector2i
			var head : Vector2i
			var offset : int = 0
			if DEEP_WATER in corners:
				base = DEEP_WATER
				head = SHALLOW_WATER
				offset = 8
			elif SHALLOW_WATER in corners:
				base = SHALLOW_WATER
				head = SAND
				offset = 4
			else:
				base = SAND
				head = GRASS
			#ABCD
			#AB
			#CD
			match corners:
				[base, base, base, base]:
					if corners[0] == DEEP_WATER:
						corner_tile.set_cell(cur_cord, 1, Vector2i(8,3))
					else:
						corner_tile.set_cell(cur_cord, 1, Vector2i(5 + offset,1))
				[base, base, base, head]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(0 + offset,0))
				[base, base, head, base]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(2 + offset,0))
				[base, base, head, head]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(1 + offset,0))
				[base, head, base, base]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(0 + offset,2))
				[base, head, base, head]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(0 + offset,1))
				[base, head, head, base]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(3 + offset,0))
				[base, head, head, head]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(3 + offset,3))
				[head, base, base, base]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(2 + offset,2))
				[head, base, base, head]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(3 + offset,1))
				[head, base, head, base]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(2 + offset,1))
				[head, base, head, head]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(2 + offset,3))
				[head, head, base, base]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(1 + offset,2))
				[head, head, base, head]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(3 + offset,2))
				[head, head, head, base]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(1 + offset,3))
				[head, head, head, head]:
					corner_tile.set_cell(cur_cord, 1, Vector2i(1 + offset,1))
				

func generate_terrain():
	set_terrain_id()
	fix_terrain_id()
	set_corner_terrain()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		randomize_noise(randi())
		clear_decor()
		generate_terrain()
