extends Control

var order_resource : Order

const AQUABERRY = preload("uid://c4fgvek4ht1hi")
const PURPLE_FRUIT = preload("uid://8wadg5f5bqtg")
const RED_FRUIT = preload("uid://itr02jcbacy8")
const WHITE_FRUIT = preload("uid://bpsq8em4s4yj4")
const YELLOW_FRUIT = preload("uid://bdxfbunt02bfn")

var fruits = [
	AQUABERRY,
	PURPLE_FRUIT,
	RED_FRUIT,
	WHITE_FRUIT,
	YELLOW_FRUIT
]

var colors = [
	Vector3(141,236,243),
	Vector3(239,230,225),
	Vector3(193,105,93),
	Vector3(160,131,191),
	Vector3(238,214,132),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Fill.uv = $Fill.polygon
	var child_idx = 0
	var fruit_idx = 0
	var base_color := Vector3.ZERO
	for req in order_resource.fruit_requirements:
		for i in range(req):
			$Fruits.get_child(child_idx).texture = fruits[fruit_idx]
			$Fruits.get_child(child_idx).visible = true
			base_color += colors[fruit_idx]
			child_idx += 1
		fruit_idx += 1
	base_color = base_color/child_idx
	var color : Color = Color(base_color.x, base_color.y, base_color.z)
	$Fill.texture.gradient.set_color(0, color)
	$TimeBar.max_value = order_resource.order_dur
	$TimeBar.value = $TimeBar.max_value

func _process(delta : float) -> void:
	print($TimeBar.value)
	$TimeBar.value -= delta
	if $TimeBar.value == 0:
		GameState.order_failed()
		queue_free()

func order_complete():
	queue_free()
