extends Node

var elapsed_time = 0.0
var order_frequency: int = 10
const ORDER_TICKET = preload("uid://5jxaioed8i86")

var hud
var boat
var terrain
var player_position
var restaurant_ui : Node2D
var in_restaurant = false
var size = Vector2i(300,300)
# Blue Brown Red White Yellow
var inventory = [0,0,0,0,0]
const MAX_INVENTORY = 12
signal inventory_modified


func _process(delta):
	if int(elapsed_time / order_frequency) != int((elapsed_time + delta) / order_frequency):
		create_order()
	elapsed_time += delta

func enter_restaurant():
	in_restaurant = true
	boat.get_node("Camera2D").enabled = false
	restaurant_ui.get_node("Camera2D").enabled = true

func exit_restaurant():
	in_restaurant = false
	boat.get_node("Camera2D").enabled = true
	restaurant_ui.get_node("Camera2D").enabled = false

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
	print("ORDER FAILED")

func check_order(blend):
	for ticket in hud.get_node("OrdersList").get_children():
		var ticket_blend = ticket.order_resource.fruit_requirements
		print(ticket_blend)
		print(blend)
		if ticket_blend == blend:
			ticket.order_complete()
			break
