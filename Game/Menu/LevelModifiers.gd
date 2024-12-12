class_name LevelModifiers
extends PanelContainer

func _ready():
	set_keyboard_style_dropdown()
	
func set_keyboard_style_dropdown():
	# add items
	for keyboard_style in Keys.Row.keys():
		%KeyboardStyle.add_item(Helpers.snake_to_capitalized(keyboard_style))
	
	# set tooltips
	%KeyboardStyle.set_item_tooltip(0, "Includes the top row, home row, and buttom row.")
	%KeyboardStyle.set_item_tooltip(1, "Includes the top row, home row, bottom row, and number row.")
