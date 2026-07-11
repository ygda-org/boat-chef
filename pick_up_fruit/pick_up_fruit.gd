extends Node2D

@onready var boat = $"../../Boat"

@onready var control = $Control

var boat_in_area = false

var fruit = (randi_range(0,4))

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Make the E-Prompt visible/invisible
	if boat_in_area == true:
		control.visible = true
	else:
		control.visible = false
	
	# If the boat is within range and player press E, increase inventory by 1 and queue_free
	if boat_in_area == true and Input.is_action_just_pressed("interact"):
		GameState.inventory[fruit] += 1
		queue_free()

func _on_area_2d_body_entered(body):
	boat_in_area = true

func _on_area_2d_body_exited(body):
	boat_in_area = false
