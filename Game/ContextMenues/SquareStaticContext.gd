extends PopupPanel

signal content_updated(content: Square.Instance, to_update: Array[Square.Values]) ## Emits when ok button is pressed.
signal cancelled() ## Emits when context is canceled.

@export var include_checkboxes: bool = true
@export var destroy_on_ok: bool = true ## Deleletes itself when ok button is pressed and there are no value errors.
@export var destroy_on_cancel: bool = true ## Deletes itself when cancel button is pressed. Or when the popup is hidden.

var default_values := Square.Instance.new('A')
var ui_element_to_square_value := {
	'Key': Square.Values.KEY,
	'Duration': Square.Values.DURATION,
	'Texture': Square.Values.TEXTURE,
	'Color': Square.Values.COLOR,
	'FallAnimation': Square.Values.FALL_ANIM,
	'GoodHitAnimation': Square.Values.GOOD_HIT_ANIM,
	'BadHitAnimation': Square.Values.BAD_HIT_ANIM
}

func _ready():
	if include_checkboxes:
		setup_checkboxes()
	set_dropdowns()

func set_dropdowns():
	var dropdowns = [%Texture, %FallAnimation, %GoodHitAnimation, %BadHitAnimation]
	var valueEnums = [Square.SquareTexture, Square.FallAnim, Square.HitAnim, Square.HitAnim]
	for i in 4:
		for values in valueEnums[i]:
			dropdowns[i].add_item(Helpers.enum_string_to_capitalized(values))
			
func setup_checkboxes():
	for container: HBoxContainer in $MainContainer.get_children():
		if container.name == 'End':
			continue # continue if container is not wanted
		var checkbox: CheckBox = container.get_node('Checkbox')
		checkbox.visible = true
		checkbox.connect('toggled', func(toggled_on: bool): _on_checkbox_checked(container, toggled_on))
		
		var ui_element = container.get_child(2) # UI element is 3rd child
		if ui_element is LineEdit or ui_element is SpinBox:
			ui_element.editable = false
		elif ui_element is Button:
			ui_element.disabled = true 

func set_content(square: Square.Instance):
	%Duration.value = square.duration
	%Key.text = square.key
	%Texture.selected = square.texture
	%Color.color = square.color
	%FallAnimation.selected = square.fall_anim
	%GoodHitAnimation.selected = square.good_hit_anim
	%BadHitAnimation.selected = square.bad_hit_anim
	
func set_default_values(square: Square.Instance = Square.Instance.new('A')):
	default_values = square

func _on_checkbox_checked(container: HBoxContainer, toggled_on: bool):
	var ui_element = container.get_child(2) # UI element is 3rd child 
	if ui_element is LineEdit or ui_element is SpinBox:
		ui_element.editable = toggled_on
	elif ui_element is Button:
		ui_element.disabled = not toggled_on

func _on_ok_pressed():
	if %Key.text.to_upper() in Keys.KEYBOARD_MAP:
		var content := Square.Instance.new(
			%Key.text.to_upper(),
			%Duration.value,
			%Texture.selected,
			%Color.color,
			%FallAnimation.selected,
			%GoodHitAnimation.selected,
			%BadHitAnimation.selected,
		)
		
		var to_update: Array[Square.Values] = []
		for container: HBoxContainer in $MainContainer.get_children():
			if container.name == 'End':
				continue
			var checkbox: CheckBox = container.get_node('Checkbox')
			if checkbox.button_pressed or not checkbox.visible:
				to_update.append(ui_element_to_square_value[container.name])
		
		content_updated.emit(content, to_update)
		if destroy_on_ok: 
			queue_free()
	else:
		%Warning.text = "Invalid key."

func _on_cancel_pressed():
	if destroy_on_cancel: 
		queue_free()
	cancelled.emit()
	
func _on_reset_pressed():
	set_content(default_values)
	
func _on_popup_hidden():
	_on_cancel_pressed()
