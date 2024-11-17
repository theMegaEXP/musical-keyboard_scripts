extends VBoxContainer

var group = ButtonGroup.new()
@onready var check_buttons: Array[CheckBox] = [
	%ResetBackgroundCheck, 
	%BackgroundColorCheck, 
	%BackgroundColorFadeCheck, 
	%BackgroundPulseColorCheck, 
	%BackgroundPulseValueCheck
]
@onready var options: Dictionary =  {
	'color': %BackgroundColor,
	'fade_color': %BackgroundColorFade,
	'fade_duration': %BackgroundColorFadeDurationDropdown,
	'pulse_color': %BackgroundPulseColor,
	'pulse': %BackgroundPulseValueInput
}

var last_pressed = null #CheckBox object or null

func _ready():
	for button in check_buttons:
		button.button_group = group
		button.connect('pressed', _on_button_pressed)
	set_dropdowns()
	
func reset():
	for check_button: CheckBox in check_buttons:
		check_button.button_pressed = false
	for node: Node in options.values():
		if node is ColorPickerButton:
			node.disabled = true
			node.color = Color.BLACK
		elif node is OptionButton:
			node.disabled = true
			node.selected = 0
		elif node is SpinBox:
			node.editable = false
			node.value = 10
			
		
func set_dropdowns():
	for duration in Durations.Duration.keys():
		options['fade_duration'].add_item(duration)
		
func set_content(bg: Background.Instance):
	match bg.animation:
		Background.Anim.NONE:
			for button: CheckBox in check_buttons:
				button.button_pressed = false
		Background.Anim.RESET:
			print('reset')
			radio_press(check_buttons[0])
		Background.Anim.SET_COLOR:
			radio_press(check_buttons[1])
			options['color'].color = bg.property_values[0]
		Background.Anim.FADE_COLOR:
			radio_press(check_buttons[2])
			for i in bg.property_types.size():
				match bg.property_types[i]:
					Background.AnimProperty.COLOR:
						options['fade_color'].color = bg.property_values[i]
					Background.AnimProperty.DURATION:
						options['fade_duration'].selected = bg.property_values[i]
		Background.Anim.PULSE_COLOR:
			radio_press(check_buttons[3])
			options['pulse_color'].color = bg.property_values[0]
		Background.Anim.PULSE:
			radio_press(check_buttons[4])
			options['pulse'].value = bg.property_values[0]
			
func get_content() -> Background.Instance:
	for i in check_buttons.size():
		if check_buttons[i].button_pressed:
			match i:
				0:
					return Background.Instance.new(
						Background.Anim.RESET
					)
				1:
					print('set color')
					return Background.Instance.new(
						Background.Anim.SET_COLOR,
						[Background.AnimProperty.COLOR],
						[options['color'].color]
					)
				2:
					return Background.Instance.new(
						Background.Anim.FADE_COLOR,
						[Background.AnimProperty.COLOR, Background.AnimProperty.DURATION],
						[options['fade_color'].color, options['fade_duration'].selected]
					)
				3:
					return Background.Instance.new(
						Background.Anim.PULSE_COLOR,
						[Background.AnimProperty.COLOR],
						[options['pulse_color'].color]
					)
				4:
					return Background.Instance.new(
						Background.Anim.PULSE,
						[Background.AnimProperty.AMOUNT],
						[options['pulse'].value]
					)
					
	return Background.Instance.new()

func radio_press(button: CheckBox):
	button.button_pressed = true
	for node in options.values():
		if node is Button:
			node.disabled = true
		elif node is SpinBox:
			node.editable = false
	
	if button.button_pressed and button == last_pressed:
		button.button_pressed = false
		last_pressed = null
		return
		
	last_pressed = button
	
	if button == check_buttons[1]:
		options['color'].disabled = false
	elif button == check_buttons[2]:
		options['fade_color'].disabled = false
		options['fade_duration'].disabled = false
	elif button == check_buttons[3]:
		options['pulse_color'].disabled = false
	elif button == check_buttons[4]:
		options['pulse'].editable = true
		
func _on_button_pressed():
	var pressed = group.get_pressed_button()
	radio_press(pressed)
	
