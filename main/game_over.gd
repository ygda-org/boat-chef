extends TextureRect

const NameBox = preload("uid://d5eucnncsauw")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Score.text = "Score: " + str(GameState.final_score)
	$AnimationPlayer.play("display")
	if Leaderboard.new_best_score != -1:
		var box = NameBox.instantiate()
		add_child(box)
		box.grab_focus()
		await box.name_entered
		Leaderboard.names[Leaderboard.new_best_score] = box.entered_name
		Leaderboard.save()
		Leaderboard.new_best_score = -1


func _on_restart_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "uid://by58fm25u4wrr")
