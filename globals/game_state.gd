extends Node

var master_volume = 0.5
var music_volume = 0.5
var sfx_volume = 0.5

var elapsed_time = 0.0
var order_frequency: int = 40
var difficulty: int = 1
const ORDER_TICKET = preload("uid://5jxaioed8i86")

var final_score = 0
var score_ticker
var hud
var boat
var terrain
var player_position
var restaurant_ui : Node2D
var in_restaurant = false
var size = Vector2i(300,300)
var tree_pos: Array[Node2D] = []
# Blue Brown Red White Yellow
var inventory = [0,0,0,0,0]
const MAX_INVENTORY = 12

var lock_orders : bool = false
var max_orders : int = 7

signal inventory_modified
signal difficulty_updated

var player_disembarked

var in_game = false

var graphics_qual_low := false


func _process(delta):
	if not in_game:
		return
	if elapsed_time > 2.0 and elapsed_time < 3.0 and not hud.get_node("OrdersList").get_children():
		create_order()
	if int(elapsed_time / order_frequency) != int((elapsed_time + delta) / order_frequency):
		if hud.orders_list.get_child_count() < max_orders:
			create_order()
	elapsed_time += delta

func enter_restaurant():
	in_restaurant = true
	boat.get_node("Camera2D").enabled = false
	restaurant_ui.get_node("Camera2D").enabled = true
	hud.order_lock.button_pressed = true
	hud._on_order_lock_pressed()

func exit_restaurant():
	in_restaurant = false
	boat.get_node("Camera2D").enabled = true
	restaurant_ui.get_node("Camera2D").enabled = false
	hud.order_lock.button_pressed = false
	hud._on_order_lock_pressed()

func add_fruit(fruit):
	var inventory_size = 0
	for f in inventory:
		inventory_size += f
	if inventory_size >= MAX_INVENTORY:
		return false
	inventory[fruit] += 1
	inventory_modified.emit()
	return true

func remove_fruit(fruit):
	inventory[fruit] -= 1
	inventory_modified.emit()

func create_order():
	if not hud:
		return
	var ticket = ORDER_TICKET.instantiate()
	var order = get_new_order_resource()
	ticket.order_resource = order
	hud.orders_list.add_child(ticket)

func get_new_order_resource():
	var resource: Order = Order.new()
	var ingredients_size = randi_range(0,2) + randi_range(1,3)
	for i in range(ingredients_size):
		resource.fruit_requirements[randi_range(0,4)] += 1
	resource.order_dur = ingredients_size * 15 + 40
	return resource

func order_failed():
	final_score = score_ticker.displayed_score
	in_game = false
	get_tree().call_deferred("change_scene_to_file", "uid://bh5icx0v1amar")

func check_order(blend):
	if order_frequency > 15:
		order_frequency -= 1
		difficulty += 1
	else:
		difficulty += 3
	difficulty_updated.emit()
	for ticket in hud.get_node("OrdersList").get_children():
		var ticket_blend = ticket.order_resource.fruit_requirements
		if ticket_blend == blend:
			ticket.order_complete()
			var score_gain = 0.0
			for amount in ticket_blend:
				score_gain += amount
			score_gain = float(score_gain) ** 1.2
			score_gain *= 200
			score_gain *= 1 + 0.2 * ticket.get_node("TimeBar").value / ticket.get_node("TimeBar").max_value
			score_gain = int(score_gain)
			await ticket.get_node("CompleteTimer").timeout
			score_ticker.add_score(score_gain, int(score_gain/120)+1)
			break
		else:
			ticket.order_failed_sound()
