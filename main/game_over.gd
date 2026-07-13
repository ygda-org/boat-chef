extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Score.text = "Score: " + str(GameState.final_score)
	$AnimationPlayer.play("display")


func _on_restart_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "uid://by58fm25u4wrr")
