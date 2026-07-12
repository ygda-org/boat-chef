extends Control

var order_resource : Order

const AQUABERRY = preload("uid://c4fgvek4ht1hi")
const WHITE_FRUIT = preload("uid://bpsq8em4s4yj4")
const RED_FRUIT = preload("uid://itr02jcbacy8")
const PURPLE_FRUIT = preload("uid://8wadg5f5bqtg")
const YELLOW_FRUIT = preload("uid://bdxfbunt02bfn")

var fruits = [
	AQUABERRY,
	WHITE_FRUIT,
	RED_FRUIT,
	PURPLE_FRUIT,
	YELLOW_FRUIT
]

var colors = [
	Vector3(141/255.0,236/255.0,243/255.0),
	Vector3(245/255.0,245/255.0,245/255.0),
	Vector3(193/255.0,105/255.0,93/255.0),
	Vector3(160/255.0,131/255.0,191/255.0),
	Vector3(238/255.0,214/255.0,132/255.0),
]

func get_gradient_colors() -> Array[Color]:
	var child_idx = 0
	var fruit_idx = 0
	var lower_color := Vector3.ZERO
	var upper_color := Vector3.ZERO
	
	var color_list : Array[int] = []
	
	#Aqua
	for i in range(order_resource.fruit_requirements[0]):
		color_list.append(0)
	#Yellow
	for i in range(order_resource.fruit_requirements[4]):
		color_list.append(4)
	#White
	for i in range(order_resource.fruit_requirements[1]):
		color_list.append(1)
	#Purple
	for i in range(order_resource.fruit_requirements[3]):
		color_list.append(3)
	#Red
	for i in range(order_resource.fruit_requirements[2]):
		color_list.append(2)
	
	for i in range(floor(len(color_list)/2)):
		lower_color += colors[color_list[i]]
		upper_color += colors[color_list[-(i + 1)]]
	if len(color_list) % 2 == 1:
		lower_color += colors[color_list[floor(len(color_list)/2)]]
		upper_color += colors[color_list[floor(len(color_list)/2)]]
	lower_color = lower_color/ ( ceil(len(color_list)/2.0) )
	upper_color = upper_color/ ( ceil(len(color_list)/2.0) )
	return [Color(lower_color.x, lower_color.y, lower_color.z), Color(upper_color.x, upper_color.y, upper_color.z)]

# Called when the node enters the scene tree for the first time.
func _ready():
	var child_idx = 0
	var fruit_idx = 0
	for req in order_resource.fruit_requirements:
		for i in range(req):
			$Fruits.get_child(child_idx).texture = fruits[fruit_idx]
			$Fruits.get_child(child_idx).visible = true
			child_idx += 1
		fruit_idx += 1
	var gradient_colors : Array[Color] = get_gradient_colors()
	$Fill.texture.gradient = Gradient.new()
	$Fill.texture.gradient.set_color(0, gradient_colors[0])
	$Fill.texture.gradient.set_color(1, gradient_colors[1])
	$TimeBar.max_value = order_resource.order_dur
	$TimeBar.value = $TimeBar.max_value
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "offset_transform_position", Vector2(0,0), 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _process(delta : float) -> void:
	$TimeBar.value -= delta
	if $TimeBar.value == 0:
		GameState.order_failed()
		queue_free()

func order_complete():
	queue_free()
