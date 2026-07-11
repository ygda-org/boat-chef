extends Control

@onready var label_blue = $Panel/GridContainer/LabelBlue
@onready var label_brown = $Panel/GridContainer/LabelBrown
@onready var label_red = $Panel/GridContainer/LabelRed
@onready var label_white = $Panel/GridContainer/LabelWhite
@onready var label_yellow = $Panel/GridContainer/LabelYellow

var order_resource

# Called when the node enters the scene tree for the first time.
func _ready():
	label_blue.text = str(order_resource.fruit_requirements[0])
	label_brown.text = str(order_resource.fruit_requirements[1])
	label_red.text = str(order_resource.fruit_requirements[2])
	label_white.text = str(order_resource.fruit_requirements[3])
	label_yellow.text = str(order_resource.fruit_requirements[4])
