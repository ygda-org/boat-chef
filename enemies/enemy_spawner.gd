extends Node2D

const STORMSPAWN = preload("uid://ggmoxc4vmxoo")
const SHARKSPAWN = preload("uid://bb58feyabqp8m")

var sharks = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SharkTimer.start(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_storm_timer_timeout() -> void:
	var storm = STORMSPAWN.instantiate()
	add_child(storm)

func _on_shark_timer_timeout() -> void:
	spawn_shark()

func on_shark_death() -> void:
	sharks -= 1
	$SharkTimer.start(1)


func find_legal_spawn(closest, furthest) -> Vector2:
	for i in range(1000):
		var spawn = Vector2(randf_range(GameState.size.x * 16 / -2, GameState.size.x  * 16 / 2), randf_range(GameState.size.y  * 16 / -2, GameState.size.y  * 16 / 2))
		var dist = spawn.distance_to(GameState.player_position) 
		if dist > closest and dist < furthest or i == 999:
			return spawn
	# forced to return bc godot is a meanie
	return Vector2.ZERO
	
func spawn_shark() -> void:
	if sharks > 1:
		return
	var shark = SHARKSPAWN.instantiate()
	shark.position = find_legal_spawn(500, 1000)
	shark.death.connect(on_shark_death)
	sharks += 1
	add_child(shark)
