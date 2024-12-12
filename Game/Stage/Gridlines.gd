# The node for this script must be a direct child of Stage
extends Node2D

const HEIGHT = 2000
const WIDTH = 3
const CENTER = 960

@onready var gap: int = get_parent().gap

func _ready():
	if get_parent().show_gridlines:
		show_lines()
		
func show_lines():
	for key: String in Keys.KEYBOARD_HOMEROW_CHARS:
		var gridline := ColorRect.new()
		gridline.size = Vector2(WIDTH, HEIGHT)
		gridline.position.x = CENTER + Keys.KEYBOARD_MAP[key].x * gap
		gridline.color.a = 0.2
		add_child(gridline)
	
func hide_lines():
	for child: ColorRect in get_children(): 
		remove_child(child)
