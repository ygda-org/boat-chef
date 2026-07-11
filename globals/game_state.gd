extends Node

var elapsed_time = 0.0
var order_frequency: int = 10
const ORDER_TICKET = preload("uid://5jxaioed8i86")

var hud
# Blue Brown Red White Yellow
var inventory = [0,0,0,0,0]
const MAX_INVENTORY = 0

var orders = []

func _process(delta):
	if int(elapsed_time / order_frequency) != int((elapsed_time + delta) / order_frequency):
		create_order()
	elapsed_time += delta

func add_fruit(fruit):
	var inventory_size = 0
	for f in inventory:
		inventory_size += f
	if inventory_size >= MAX_INVENTORY:
		return false
	inventory[fruit] += 1
	return true

func create_order():
	var ticket = ORDER_TICKET.instantiate()
	var order = get_new_order_resource()
	ticket.order_resource = order
	hud.orders_list.add_child(ticket)

func get_new_order_resource():
	return load("res://orders/orders/test_order.tres")
