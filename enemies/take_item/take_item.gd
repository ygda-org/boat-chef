extends Area2D

func _on_body_entered(body):
	if GameState.in_restaurant:
		return
	if body == GameState.boat:
		var valid_idx = []
		var i = 0
		for f_count in GameState.inventory:
			for j in range(f_count):
				valid_idx.append(i)
			i += 1
		if len(valid_idx) == 0:
			return
		GameState.inventory[valid_idx[randi_range(0,len(valid_idx) - 1)]] -= 1
		GameState.emit_signal("inventory_modified")
