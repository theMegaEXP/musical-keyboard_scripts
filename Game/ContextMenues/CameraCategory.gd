extends VBoxContainer

var container_name_to_enum := {
	'ResetAll': Camera.Anim.RESET_ALL,
	'ResetRotation': Camera.Anim.RESET_ROTATION,
	'ResetZoom': Camera.Anim.RESET_ZOOM,
	'Rotate': Camera.Anim.ROTATE,
	'Zoom': Camera.Anim.ZOOM,
	'RotateLoop': Camera.Anim.ROTATION_LOOP,
	'ZoomLoop': Camera.Anim.ZOOM_LOOP
}

var enum_to_container_index := {
	Camera.Anim.RESET_ALL: 0,
	Camera.Anim.RESET_ROTATION: 1,
	Camera.Anim.RESET_ZOOM: 2,
	Camera.Anim.ROTATE: 3,
	Camera.Anim.ZOOM: 4,
	Camera.Anim.ROTATION_LOOP: 5,
	Camera.Anim.ZOOM_LOOP: 6
}

@onready var containers: Array[Node] = $Content.get_children()
@onready var checkboxes: Array[CheckBox] = get_checkboxes()

func _ready():
	set_dropdowns()
	
func reset():
	uncheck_checkboxes([0, 1, 2, 3, 4, 5, 6])
	for container: Node in containers:
		if container.has_node('Intensity'):
			container.get_node('Intensity/Dropdown').selected = 0
		if container.has_node('Duration'):
			container.get_node('Duration/Dropdown').selected = 0
		if container.has_node('Ease'):
			container.get_node('Ease/Dropdown').selected = 0

func set_dropdowns():
	for container: Node in containers:
		container.get_node('Checkbox').connect('toggled', func(toggled_on: bool): _on_checkbox_press(container, toggled_on))
		
		if container.has_node('Intensity'):
			if container.name == 'Rotate' or container.name == 'RotateLoop':
				set_dropdown(container.get_node('Intensity/Dropdown'), Camera.Rotation)
			elif container.name == 'Zoom' or container.name == 'ZoomLoop':
				set_dropdown(container.get_node('Intensity/Dropdown'), Camera.Zoom)
		if container.has_node('Duration'):
			set_dropdown(container.get_node('Duration/Dropdown'), Durations.Duration)
		if container.has_node('Ease'):
			set_dropdown(container.get_node('Ease/Dropdown'), Ease.EASE)
	
func set_dropdown(dropdown: OptionButton, e: Dictionary):
	for item in e.keys():
		dropdown.add_item(Helpers.enum_string_to_capitalized(item))

func set_content(cameras: Array[Camera.Instance]):
	for camera: Camera.Instance in cameras:
		var container = containers[enum_to_container_index[camera.animation]]
		container.get_node('Checkbox').button_pressed = true
		for i: int in camera.property_types.size():
			match camera.property_types[i]:
				Camera.AnimProperty.DURATION:
					container.get_node('Duration/Dropdown').selected = camera.property_values[i]
				Camera.AnimProperty.INTENSITY:
					container.get_node('Intensity/Dropdown').selected = camera.property_values[i]
				Camera.AnimProperty.EASE:
					container.get_node('Ease/Dropdown').selected = camera.property_values[i]

func get_content() -> Array[Camera.Instance]:
	var cameras: Array[Camera.Instance] = []
	for container: Node in containers:
		var properties: Array[Camera.AnimProperty] = []
		var values = []
		# If checkbox is checked
		if container.get_node('Checkbox').button_pressed:
			if container.has_node('Duration'):
				properties.append(Camera.AnimProperty.DURATION)
				values.append(container.get_node('Duration/Dropdown').selected)
			if container.has_node('Intensity'):
				properties.append(Camera.AnimProperty.INTENSITY)
				values.append(container.get_node('Intensity/Dropdown').selected)
			if container.has_node('Ease'):
				properties.append(Camera.AnimProperty.EASE)
				values.append(container.get_node('Ease/Dropdown').selected)
			cameras.append(Camera.Instance.new(container_name_to_enum[container.name], Camera.ints_to_anim_properties(properties), values))
	return cameras
	
func get_checkboxes() -> Array[CheckBox]:
	var arr: Array[CheckBox] = []
	for container: Node in containers:
		arr.append(container.get_node('Checkbox'))
	return arr
	
func uncheck_checkboxes(indexes: Array[int]):
	for index: int in indexes:
		checkboxes[index].button_pressed = false

func _on_checkbox_press(container: Node, toggled_on: bool):
	var checkbox = container.get_node('Checkbox')
	
	if toggled_on:
		match checkboxes.find(checkbox):
			0:
				uncheck_checkboxes([1, 2, 3, 4, 5, 6])
			1:
				uncheck_checkboxes([0, 3, 5])
			2:
				uncheck_checkboxes([0, 4, 6])
			3:
				uncheck_checkboxes([0, 1, 5])
			4:
				uncheck_checkboxes([0, 2, 6])
			5:
				uncheck_checkboxes([0, 1, 3])
			6:
				uncheck_checkboxes([0, 2, 4])
		
	if container.has_node('Intensity'):
		container.get_node('Intensity/Dropdown').disabled = not toggled_on
	if container.has_node('Duration'):
		container.get_node('Duration/Dropdown').disabled = not toggled_on
	if container.has_node('Ease'):
		container.get_node('Ease/Dropdown').disabled = not toggled_on
	
