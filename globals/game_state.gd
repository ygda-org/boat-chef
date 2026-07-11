extends Node

var elapsed_time = 0.0

var hud
# Blue Brown Red White Yellow
var inventory = [0,0,0,0,0]

var orders = [[1,2,3,0,1],[3,2,0,0,0,0]]

func _process(delta):
	elapsed_time += delta
