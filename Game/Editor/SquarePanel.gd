class_name SquarePanel
extends Panel

@export var square_texture: Texture = preload("res://Resources/Textures/Square/Blank.tres") ## Texture for every square in the grid.
@export var unselected_style_box: StyleBoxFlat ## Stylebox for when the square is not selected
@export var selected_style_box: StyleBoxFlat ## Stylebox for when the square is selected

@onready var square = preload("res://Scenes/LevelEditor/SquareStatic.tscn")

var is_square_added: bool = false
var is_selected: bool = false
var point_index: int = -1
var panel_index: int = 0

signal press(point_index: int, panel_index: int) ## Emmits a signal with the id of the pressed square
signal shift_press(point_index: int, panel_index: int) ## Emmits a signal with the id of the pressed square while the user is holding shift. Will be called instead of control if both shift and ctrl are held down.
signal ctrl_press(point_index: int, panel_index: int) ## Emmits a signal with the id of the pressed square while the user is holding shfit

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.is_key_pressed(KEY_SHIFT):
			shift_press.emit(point_index, panel_index)
		elif Input.is_key_pressed(KEY_CTRL):
			ctrl_press.emit(point_index, panel_index)
		else:
			press.emit(point_index, panel_index)

func get_square() -> SquareStatic:
	return get_child(0)

func add_square(content: Square.Instance):
	if is_square_added:
		get_square().set_content(content)
	else:
		var new_square: SquareStatic = square.instantiate()
		new_square.set_content(content)
		add_child(new_square)
		is_square_added = true
	
func remove_square():
	if is_square_added:
		remove_child(get_child(0))
		is_square_added = false
		
func set_selected():
	add_theme_stylebox_override("panel", selected_style_box)
	is_selected = true
	
func unset_selected():
	add_theme_stylebox_override("panel", unselected_style_box)
	is_selected = false
	

