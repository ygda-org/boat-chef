extends Node

const STORMSPAWN = preload("uid://ggmoxc4vmxoo")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_storm_timer_timeout() -> void:
	var storm = STORMSPAWN.instantiate()
