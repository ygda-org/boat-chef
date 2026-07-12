extends Node

var time_elapsed = 0
var total_time = 0.1

func _ready():
	get_tree().paused = true


func _process(delta):
	time_elapsed += delta
	if time_elapsed > total_time:
		get_tree().paused = false
		queue_free()
