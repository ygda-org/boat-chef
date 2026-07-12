extends Area2D

@onready var boat = $"../../../Boat"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body == boat:
		GameState.inventory[randi_range(0,4)] -= 1
		GameState.emit_signal("inventory_modified")
		print("shouldve stolen one")
