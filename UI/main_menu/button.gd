extends TextureButton
@onready var ygda_logo = $"../YGDALogo"
@onready var ygda_logo_sprite : AnimatedSprite2D = $"../YGDALogo/YGDALogoSprite"
@onready var ygda_sting = $"../YGDALogo/YGDASting"
@onready var color_rect = $"../YGDALogo/ColorRect"
@onready var music = $"../Music"

@onready var play_game_button_sound = $PlayGameButtonSound
@onready var animation: AnimationPlayer = get_parent().get_node("AnimationPlayer")

@onready var hover_sound = $HoverSound

# Called when the node enters the scene tree for the first time.
func _ready():
	ygda_logo.visible = true
	ygda_sting.play()
	var tween_opening = get_tree().create_tween()
	tween_opening.tween_property(ygda_logo_sprite, "self_modulate", Color(1.0,1.0,1.0,1.0), 1.0).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1.41).timeout
	ygda_logo_sprite.play("default")
	await get_tree().create_timer(2.59).timeout
	var tween_closing = get_tree().create_tween()
	tween_closing.tween_property(ygda_logo_sprite, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0).set_trans(Tween.TRANS_SINE)
	tween_closing.parallel().tween_property(color_rect, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 1.0).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1.41).timeout 
	ygda_sting.playing = false
	ygda_logo.visible = false

	music.playSound()

func _on_settings_pressed():
	animation.play("buttons_out")
	play_game_button_sound.playSound()

func _on_credits_pressed():
	play_game_button_sound.playSound()
	animation.play("buttons_out")
	animation.queue("credits_in")

func _on_pressed():
	play_game_button_sound.playSound()
	animation.play("buttons_out")
	get_tree().change_scene_to_file("res://main/main.tscn")


func _on_back_pressed():
	play_game_button_sound.playSound()
	animation.play_backwards("credits_in")
	await animation.animation_finished
	animation.play_backwards("buttons_out")


func _on_mouse_entered():
	hover_sound.playSound()

func _on_settings_mouse_entered():
	hover_sound.playSound()

func _on_credits_mouse_entered():
	hover_sound.playSound()
