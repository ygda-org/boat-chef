extends Control

@onready var label_blue = $GridContainer/LabelBlue
@onready var label_white = $GridContainer/LabelWhite
@onready var label_red = $GridContainer/LabelRed
@onready var label_purple = $GridContainer/LabelPurple
@onready var label_yellow = $GridContainer/LabelYellow

@onready var orders_list = $OrdersList

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.hud = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	label_blue.text = str(GameState.inventory[0])
	label_white.text = str(GameState.inventory[1])
	label_red.text = str(GameState.inventory[2])
	label_purple.text = str(GameState.inventory[3])
	label_yellow.text = str(GameState.inventory[4])
