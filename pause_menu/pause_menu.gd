extends Control

var can_unpause = false

@onready var master_volume_slider = $MasterVolumeSlider
@onready var music_volume_slider = $MusicVolumeSlider
@onready var sfx_volume_slider = $SFXVolumeSlider

func _ready():
	master_volume_slider.value = GameState.master_volume
	music_volume_slider.value = GameState.music_volume
	sfx_volume_slider.value = GameState.sfx_volume
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_unpause == false:
		if not Input.is_action_pressed("pause"):
			can_unpause = true
	
	if Input.is_action_just_pressed("pause") and can_unpause == true:
		get_tree().paused = false
		queue_free()


func _on_master_volume_slider_value_changed(value):
	GameState.master_volume = value


func _on_music_volume_slider_value_changed(value):
	GameState.music_volume = value


func _on_sfx_volume_slider_value_changed(value):
	GameState.sfx_volume = value
