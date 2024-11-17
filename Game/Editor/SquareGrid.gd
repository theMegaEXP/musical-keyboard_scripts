extends HBoxContainer

signal square_changes

@export var grid_length: int = 16
@export_range(1, 8) var max_height: int = 4

@onready var point_inst := preload("res://Scenes/LevelEditor/Point.tscn")
@onready var square_context := preload("res://Scenes/LevelEditor/SquareStaticContext.tscn")

var default_square_values := Square.Instance.new('A', 0, 0, Color.BLACK)
var selected: Array[SquarePanel] = []
var clipboard: Array[SquareClipboard]
var clipboard_start_index: int = 0
	
class SquareClipboard:
	var point_index: int
	var panel_index: int
	var data: Square.Instance
	
	func _init(point_index: int, panel_index: int, data: Square.Instance):
		self.point_index = point_index
		self.panel_index = panel_index
		self.data = data

func _ready():
	$Point.free()
	generate_panels()

func _input(event):
	if event.is_action_pressed('insert'):
		add_square_static_context()
	elif event.is_action_pressed('left'):
		select_prev()
	elif event.is_action_pressed('right') or event.is_action_pressed('space'):
		select_next()
	elif event.is_action_pressed('down'):
		select_below()
	elif event.is_action_pressed('up'):
		select_above()
	elif event.is_action_pressed('backspace'):
		delete_from_selected()
		select_prev()
	elif event.is_action_pressed('delete'):
		delete_from_selected()
	elif event.is_action_pressed('copy'):
		copy()
	elif event.is_action_pressed('cut'):
		cut()
	elif event.is_action_pressed('paste'):
		paste()
	elif event is InputEventKey and event.pressed \
	and event.keycode in Keys.KEY_TO_KEYBOARD_CHAR:
		for panel: SquarePanel in selected:
			var content = default_square_values.clone()
			content.key = Keys.KEY_TO_KEYBOARD_CHAR[event.keycode]
			panel.add_square(content)
			select_next()

func generate_panels():
	var panel_path = 'Squares/SquarePanel'
	for i: int in grid_length:
		var new_point = point_inst.instantiate()
		new_point.max_height = max_height
		var panel = new_point.get_node(panel_path)
		panel.point_index = i
		connect_panel_signals(panel)
		call_deferred("add_child", new_point)
		print(i)

# Called by each newly added SquraePanel. SquarePanels are adding in each Point
func connect_panel_signals(panel: SquarePanel):
	panel.connect('press', _on_panel_press)
	panel.connect('ctrl_press', _on_panel_ctrl_press)
	panel.connect('shift_press', _on_panel_shift_press)
	panel.connect('tree_exited', func(): _on_panel_removed(panel))
	
func add_square_static_context():
	var context = square_context.instantiate()
	context.connect('content_updated', _on_square_context_ok)
	add_child(context) # Add context to scene then set values to avoid values not being correctly set
	if selected.size() == 1 and selected[0].is_square_added:
		var content: Square.Instance = selected[0].get_square().square_instance
		context.set_default_values(content)
		context.set_content(content)
	else:
		context.set_default_values(default_square_values)
		context.set_content(default_square_values)
	

func get_sequence() -> Array[Sequence.Point]:
	var seq: Array[Sequence.Point] = []
	for i: int in grid_length:
		var squares: Array[Square.Instance]
		var anims = get_point(i).get_node('AnimationSelector')
		for j: int in get_panel_count(i):
			var panel = get_panel(i, j)
			if panel.is_square_added:
				squares.append(panel.get_square().square_instance)
		seq.append(Sequence.Point.new(squares, anims.cameras, anims.bg))
	return seq
	
func set_sequence(seq: Array[Sequence.Point]):
	reset()
	
	# Wait for reset() method to finish
	await Engine.get_main_loop().process_frame
	
	var point_index: int = 0
	for point: Sequence.Point in seq:
		var ui_point = get_point(point_index)
		
		# Set Square data
		var square_index: int = 0
		for square: Square.Instance in point.squares:
			if square_index > 0:
				ui_point.add_panel()
			var panel = get_panel(point_index, square_index)
			panel.add_square(square)
			square_index += 1
			
		# Set Camera and Background animation data
		ui_point.animation_selector.update_content(point.camera_animations, point.background_animation)
		
		point_index += 1
		if point_index == grid_length:
			break
	
func reset():
	for child in get_children():
		child.free()
	generate_panels()




# Functions below are to retrived child nodes and their data

func get_panel(point_index: int, panel_index: int) -> SquarePanel:
	var point = get_child(point_index)
	var panel = point.get_node('Squares').get_child(panel_index)
	return panel
	
func get_panel_count(point_index: int) -> int:
	var point = get_child(point_index)
	return point.get_node('Squares').get_child_count()
	
func get_point(point_index: int) -> VBoxContainer:
	return get_child(point_index)




# Functions below are for manipulating selected panels and adding squares

func delete_from_selected():
	for panel: SquarePanel in selected:
		if panel.is_square_added:
			panel.remove_square()
	
func remove_all_selected():
	for panel: SquarePanel in selected:
		panel.unset_selected()
	selected = []
	
func add_selected(panel: SquarePanel):
	panel.set_selected()
	selected.append(panel)
	
func select_next():
	if selected.is_empty():
		return
	var last_selected_index: int = selected[-1].point_index
	if last_selected_index < grid_length - 1:
		remove_all_selected()
		add_selected(get_panel(last_selected_index + 1, 0))
		
func select_prev():
	if selected.is_empty():
		return
	var last_selected_index: int = selected[-1].point_index
	if last_selected_index > 0:
		remove_all_selected()
		add_selected(get_panel(last_selected_index - 1, 0))
		
func select_below():
	if selected.is_empty():
		return
	var last_selected: SquarePanel = selected[-1]
	if last_selected.panel_index < get_panel_count(last_selected.point_index) - 1:
		remove_all_selected()
		add_selected(get_panel(last_selected.point_index, last_selected.panel_index + 1))
	
func select_above():
	if selected.is_empty():
		return
	var last_selected: SquarePanel = selected[-1]
	if last_selected.panel_index > 0:
		remove_all_selected()
		add_selected(get_panel(last_selected.point_index, last_selected.panel_index - 1))


# Functions below are for copy/cut/paste 

func copy():
	clipboard = []
	clipboard_start_index = grid_length
	for panel in selected:
		clipboard_start_index = min(panel.point_index, clipboard_start_index)
		clipboard.append(
			SquareClipboard.new(
				panel.point_index, 
				panel.panel_index, 
				panel.get_square().square_instance if panel.is_square_added else null
			)
		)
		
func cut():
	copy()
	delete_from_selected()

func paste():
	if selected.is_empty() or clipboard.is_empty():
		return
	var start_index = selected[-1].point_index
	remove_all_selected()
	for clip in clipboard:
		var point_index = start_index + clip.point_index - clipboard_start_index
		if point_index < grid_length:
			# Add extra layers if needed
			var panel_count = get_panel_count(point_index)
			var point = get_point(point_index)
			if clip.panel_index >= panel_count:
				for i: int in range(panel_count, clip.panel_index + 1):
					point.add_panel()
			var panel = get_panel(point_index, clip.panel_index)
			add_selected(panel)
			if clip.data:
				panel.add_square(clip.data)




# Functions below are for signals recieved from child nodes

func _on_square_context_ok(content_recieved: Square.Instance, to_update: Array[Square.Values]):
	var enum_keys = Square.Values.keys()
	var enum_value_to_str: Dictionary = {}
	for value: Square.Values in to_update:
		enum_value_to_str[value] = enum_keys[value].to_lower()

	# Set all panels with a SquareStatic to include updated content
	for panel: SquarePanel in selected:
		if panel.is_square_added:
			var square: SquareStatic = panel.get_square()
			var content = square.square_instance
			for value: Square.Values in to_update:
				var enum_str = enum_value_to_str[value]
				content.set(enum_str, content_recieved.get(enum_str))
			square.set_content(content, default_square_values)
	
func _on_panel_removed(panel: SquarePanel):
	if panel.is_selected:
		selected.remove_at(selected.find(panel))
	
func _on_panel_press(point_index: int, panel_index: int):
	var panel: SquarePanel = get_panel(point_index, panel_index)
	
	if not panel.is_selected or selected.size() > 1:
		remove_all_selected()
		add_selected(panel)
	else:
		remove_all_selected()
		panel.unset_selected()
		
func _on_panel_ctrl_press(point_index: int, panel_index: int):
	var panel: SquarePanel = get_panel(point_index, panel_index)
	if not panel.is_selected:
		add_selected(panel)
	else:
		panel.unset_selected()
		selected.remove_at(selected.find(panel))
		
func _on_panel_shift_press(point_index: int, panel_index: int):
	var panel: SquarePanel = get_panel(point_index, panel_index)
	if not selected.is_empty():
		var last_panel_point: int = selected[-1].point_index
		var loop_range = range(last_panel_point + 1, point_index + 1) if last_panel_point <= point_index else range(point_index, last_panel_point)
		for i: int in loop_range:
			for j: int in get_panel_count(i):
				var new_panel_select: SquarePanel = get_panel(i, j)
				add_selected(new_panel_select)
		for i: int in get_panel_count(last_panel_point):
			var new_panel_select: SquarePanel = get_panel(last_panel_point, i)
			if not new_panel_select.is_selected:
				add_selected(new_panel_select)
	elif not panel.is_selected:
		add_selected(panel)
