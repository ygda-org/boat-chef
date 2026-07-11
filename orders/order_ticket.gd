extends Control

@onready var label_blue = $GridContainer/LabelBlue
@onready var label_brown = $GridContainer/LabelBrown
@onready var label_red = $GridContainer/LabelRed
@onready var label_white = $GridContainer/LabelWhite
@onready var label_yellow = $GridContainer/LabelYellow

var order_resource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label_blue.text = str(order_resource.fruit_requirements[0])
	label_brown.text = str(order_resource.fruit_requirements[1])
	label_red.text = str(order_resource.fruit_requirements[2])
	label_white.text = str(order_resource.fruit_requirements[3])
	label_yellow.text = str(order_resource.fruit_requirements[4])
