extends TextureButton

@export var pickup_texture: Texture2D
@export var fruit_texture: Texture2D
@export var fruit_num: int
@export var center: bool # for acade to grab focus on restaurant enter
const SPAWNABLE = preload("uid://ch0s7fokc1447")


func _ready():
	material = ShaderMaterial.new()
	material.shader = load("uid://daj2jngfkklpp")
	texture_normal = pickup_texture
	update_visibility()
	GameState.inventory_modified.connect(update_visibility)
	if center:
		GameState.restaurant_entered.connect(grab_focus)

func update_visibility():
	if GameState.inventory[fruit_num]:
		material.set_shader_parameter("overlay_color", Color(1.0, 1.0, 1.0, 0.0))
	else:
		material.set_shader_parameter("overlay_color", Color(0.0, 0.0, 0.0, 1.0))

func _on_button_down():
	if not GameState.inventory[fruit_num]:
		return
	if GameState.arcade_mode:
		arcade_press()
		return
	GameState.remove_fruit(fruit_num)
	var fruit = SPAWNABLE.instantiate()
	fruit.texture_to_set = fruit_texture
	fruit.fruit_type = fruit_num
	get_parent().get_parent().add_child(fruit)
	fruit.global_position = get_global_mouse_position()
	fruit.grabbed = true

func arcade_press():
	GameState.remove_fruit(fruit_num)
	var fruit = SPAWNABLE.instantiate()
	fruit.texture_to_set = fruit_texture
	fruit.fruit_type = fruit_num
	get_parent().get_parent().add_child(fruit)
	fruit.global_position = get_parent().global_position + Vector2(960 + randf_range(-15,15), 200)

func _on_focus_entered():
	if GameState.inventory[fruit_num]:
		material.set_shader_parameter("overlay_color", Color(1.0, 1.0, 1.0, 0.314))
	else:
		material.set_shader_parameter("overlay_color", Color(0.0, 0.2, 0.2, 0.314))

func _on_focus_exited():
	if GameState.inventory[fruit_num]:
		material.set_shader_parameter("overlay_color", Color(1.0, 1.0, 1.0, 0.0))
	else:
		material.set_shader_parameter("overlay_color", Color(0.0, 0.0, 0.0, 1.0))
