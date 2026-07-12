extends Node2D

const STORMSPAWN = preload("uid://ggmoxc4vmxoo")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_storm_timer_timeout() -> void:
	var storm = STORMSPAWN.instantiate()
	add_child(storm)
