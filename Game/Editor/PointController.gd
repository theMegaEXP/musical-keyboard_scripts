extends VBoxContainer

@onready var square_panel = preload("res://Scenes/LevelEditor/SquarePanel.tscn")
@onready var top_parent = get_parent()
@onready var animation_selector = $AnimationSelector

var max_height: int = 1:
	set(h):
		assert(h > 0, "Max height must be greater than 0.")
		max_height = h

func _ready():
	$AddBtn.focus_mode = Control.FOCUS_NONE
	$SubtractBtn.focus_mode = Control.FOCUS_NONE
	$SubtractBtn.visible = false

func add_panel():
	var new_panel: SquarePanel = square_panel.instantiate()
	new_panel.point_index = $Squares.get_child(0).point_index # Set point index to be the same
	new_panel.panel_index = $Squares.get_child_count() # Set the panel index to the next available int by using the children count
	top_parent.connect_panel_signals(new_panel) # Set signals through top parent Editor
	
	if $Squares.get_child_count() > 1:
		$SubtractBtn.visible = true
	if $Squares.get_child_count() < max_height:
		$Squares.add_child(new_panel)
		
func remove_panel():
	var to_remove: SquarePanel = $Squares.get_children()[-1]
	$Squares.remove_child(to_remove)
	if $Squares.get_child_count() == 1:
		$SubtractBtn.visible = false
	$AddBtn.visible = true

func _on_add():
	add_panel()
	
func _on_subtract():
	remove_panel()

#func _on_mouse_entered():
	#$AddBtn.visible = true
	#if $Squares.get_child_count() > 1:
		#$SubtractBtn.visible = true
#
#func _on_mouse_exited():
	#$AddBtn.visible = false
	#$SubtractBtn.visible = false
