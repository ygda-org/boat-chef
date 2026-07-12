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
	Vector3(141,236,243),
	Vector3(239,230,225),
	Vector3(193,105,93),
	Vector3(160,131,191),
	Vector3(238,214,132),
]

func get_gradient_colors() -> Array[Color]:
	var child_idx = 0
	var fruit_idx = 0
	var base_color := Vector3.ZERO
	
	var counts : Array[int] = [0,0,0,0,0]
	
	for req in order_resource.fruit_requirements:
		for i in range(req):
			base_color += colors[fruit_idx]
			child_idx += 1
			#counts[fruit_idx]
		fruit_idx += 1
	base_color = base_color/child_idx
	var color : Color = Color(base_color.x/255.0, base_color.y/255.0, base_color.z/255.0)
	return [color, Color(1.0,1.0,1.0)]

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
