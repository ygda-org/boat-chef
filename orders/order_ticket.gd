extends Control

var order_resource

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
