extends Button
@onready var ygda_logo = $"../YGDALogo"
@onready var ygda_logo_sprite = $"../YGDALogo/YGDALogoSprite"
@onready var ygda_sting = $"../YGDALogo/YGDASting"

# Called when the node enters the scene tree for the first time.
func _ready():
	ygda_logo.visible = true
	ygda_logo_sprite.play("default")
	ygda_sting.play()
	await get_tree().create_timer(4).timeout
	ygda_sting.playing = false
	ygda_logo.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_up():
	get_tree().change_scene_to_file("res://main/main.tscn")
