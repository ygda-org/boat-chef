extends StaticBody2D

func set_boundaries(size: int):
	for child in get_children():
		child.shape.distance = size / -2.0
