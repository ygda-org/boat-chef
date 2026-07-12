extends Area2D

@onready var boat = $"../../../Boat"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if GameState.in_restaurant:
		return
	if body == boat:
		var valid_idx = []
		var i = 0
		for f_count in GameState.inventory:
			if f_count > 0:
				valid_idx.append(i)
			i += 1
		if len(valid_idx) == 0:
			return
		GameState.inventory[valid_idx[randi_range(0,len(valid_idx) - 1)]] -= 1
		GameState.emit_signal("inventory_modified")
		print("shouldve stolen one")
