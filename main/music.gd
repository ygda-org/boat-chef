extends Node

@onready var malik_theme = $MalikTheme
@onready var erina_theme = $ErinaTheme
@onready var animation_player = $AnimationPlayer

var music = randi_range(0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	music = randi_range(0,1)
	if music == 0:
		malik_theme.playSound()
	else:
		erina_theme.playSound()

func _on_malik_theme_finished():
	malik_theme.play()
	malik_theme.seek(0.0)
	if randi_range(0, 1):
		erina_theme.play()
		animation_player.play_backwards("erina_out")
		await get_tree().create_timer(5.0).timeout
		malik_theme.stop()

func _on_erina_theme_finished():
	erina_theme.play()
	erina_theme.seek(39.18)
	if randi_range(0, 1):
		malik_theme.play()
		animation_player.play("erina_out")
		await get_tree().create_timer(5.0).timeout
		erina_theme.stop()
