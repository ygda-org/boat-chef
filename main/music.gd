extends Node

@onready var malik_theme = $MalikTheme
@onready var erina_theme = $ErinaTheme

var music = randi_range(0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	play_song()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_malik_theme_finished():
	finished()

func _on_erina_theme_finished():
	finished()
	
func play_song():
	if music == 0:
		malik_theme.playSound()
		await get_tree().create_timer(3.0).timeout
	else:
		erina_theme.playSound()
		await get_tree().create_timer(3.0).timeout

func finished():
	music = randi_range(0,1)
	play_song()
