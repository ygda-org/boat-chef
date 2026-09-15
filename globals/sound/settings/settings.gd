extends Control

@onready var master_volume_slider = $MasterVolumeSlider
@onready var music_volume_slider = $MusicVolumeSlider
@onready var sfx_volume_slider = $SFXVolumeSlider

func _ready():
	master_volume_slider.value = GameState.master_volume
	music_volume_slider.value = GameState.music_volume
	sfx_volume_slider.value = GameState.sfx_volume

func _on_master_volume_slider_value_changed(value):
	GameState.master_volume = value


func _on_music_volume_slider_value_changed(value):
	GameState.music_volume = value


func _on_sfx_volume_slider_value_changed(value):
	GameState.sfx_volume = value

func _on_graphics_button_pressed() -> void:
	GameState.graphics_qual_low = $GraphicsButton.button_pressed
