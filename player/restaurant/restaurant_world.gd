extends Node2D

@onready var enter_restaurant_sound = $EnterRestaurantSound

var boat_in_area = false

var button

func _ready():
	if GameState.arcade_mode:
		button = $ArcadeInteractButton
		$Label.queue_free()
	else:
		button = $Label
		$ArcadeInteractButton.queue_free()

func _process(_delta):
	if boat_in_area == true:
		button.visible = true
	else:
		button.visible = false
	if boat_in_area and Input.is_action_just_pressed("interact") and GameState.in_restaurant == false:
		GameState.enter_restaurant()
		enter_restaurant_sound.playSound()

func _on_area_2d_body_entered(_body):
	boat_in_area = true

func _on_area_2d_body_exited(_body):
	boat_in_area = false
