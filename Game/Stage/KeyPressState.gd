class_name KeyPressState

extends Control

@export var key_state = Square.PressState.GOOD

func _ready():
	match key_state:
		Square.PressState.MISS:
			$Text.text = "Miss"
			$Text.add_theme_color_override("font_color", Color.DARK_RED)
		Square.PressState.POOR:
			$Text.text = "Poor"
			$Text.add_theme_color_override("font_color", Color.ORANGE_RED)
		Square.PressState.GOOD:
			$Text.text = "good"
			$Text.add_theme_color_override("font_color", Color.LIME_GREEN)
		Square.PressState.GREAT:
			$Text.text = "Great"
			$Text.add_theme_color_override("font_color", Color.DARK_GREEN)
		Square.PressState.EXCELLENT:
			$Text.text = "Excellent!"
			$Text.add_theme_color_override("font_color", Color.GOLD)
			
	$Animator.play("activate")

