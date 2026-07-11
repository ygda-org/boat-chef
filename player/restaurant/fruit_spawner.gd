extends TextureButton

@export var pickup_texture: Texture2D
@export var fruit_texture: Texture2D
@export var fruit_num: int
const SPAWNABLE = preload("uid://ch0s7fokc1447")

func _ready():
	texture_normal = pickup_texture

func _on_button_down():
	var fruit = SPAWNABLE.instantiate()
	fruit.texture_to_set = fruit_texture
	get_parent().get_parent().add_child(fruit)
	fruit.global_position = global_position
	fruit.grabbed = true
