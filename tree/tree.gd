extends Node2D

@onready var control = $Control

var boat_in_area = false

var fruit
@export var fruit_colors: Array[Color]

const TREE_PARTICLES = preload("uid://blfwcc7chqy1h")

@onready var fruit_collect_sound = $FruitCollectSound

var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	fruit = randi_range(0,4)
	$Sprite2D.material.set_shader_parameter("fruit_color", fruit_colors[fruit])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	# Make the E-Prompt visible/invisible
	if boat_in_area == true:
		control.visible = true
	else:
		control.visible = false
	
	# If the boat is within range and player press E, increase inventory by 1 and queue_free
	if boat_in_area and Input.is_action_just_pressed("interact") and collected == false:
		if GameState.add_fruit(fruit):
			$CollisionShape2D.disabled = true
			var particles = TREE_PARTICLES.instantiate()
			get_parent().add_child(particles)
			particles.global_position = global_position
			particles.emitting = true
			visible = false
			fruit_collect_sound.playSound()
			collected = true
			await fruit_collect_sound.finished
			queue_free()

func _on_area_2d_body_entered(_body):
	boat_in_area = true

func _on_area_2d_body_exited(_body):
	boat_in_area = false
