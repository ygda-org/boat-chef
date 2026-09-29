extends Control

func _process(_delta):
	var ret = "Best score:\n"
	for i in range(Leaderboard.names.size()):
		ret += "{0}: {1}\n".format([Leaderboard.names[i], str(int(Leaderboard.leaderboards[i]))])
	$Panel/Label.text = ret
