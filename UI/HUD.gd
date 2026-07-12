extends Control

@onready var orders_list = $OrdersList

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

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.hud = self
	GameState.inventory_modified.connect(update_fruit)

func update_fruit():
	var child_idx = 0
	var fruit_idx = 0
	for child in $Fruits.get_children():
		child.visible = false
	for req in GameState.inventory:
		for i in range(req):
			$Fruits.get_child(child_idx).texture = fruits[fruit_idx]
			$Fruits.get_child(child_idx).visible = true
			child_idx += 1
		fruit_idx += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_order_lock_pressed() -> void:
	if $OrderLock.button_pressed:
		GameState.lock_orders = true
	else:
		GameState.lock_orders = false
