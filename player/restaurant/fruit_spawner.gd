extends TextureButton

@export var pickup_texture: Texture2D
@export var fruit_texture: Texture2D
@export var fruit_num: int
const SPAWNABLE = preload("uid://ch0s7fokc1447")

func _ready():
	texture_normal = pickup_texture
	GameState.inventory_modified.connect(update_visibility)

func update_visibility():
	visible = bool(GameState.inventory[fruit_num])

func _on_button_down():
	if not GameState.inventory[fruit_num]:
		return
	GameState.remove_fruit(fruit_num)
	var fruit = SPAWNABLE.instantiate()
	fruit.texture_to_set = fruit_texture
	fruit.fruit_type = fruit_num
	get_parent().get_parent().add_child(fruit)
	fruit.global_position = get_global_mouse_position()
	fruit.grabbed = true
