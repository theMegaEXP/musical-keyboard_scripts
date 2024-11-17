class_name KeyPressState

extends Control

@export var key_state = Enums.KeyState.GOOD

func _ready():
	match key_state:
		Enums.KeyState.MISS:
			$Text.text = "Miss"
			$Text.add_theme_color_override("font_color", Color.DARK_RED)
		Enums.KeyState.POOR:
			$Text.text = "Poor"
			$Text.add_theme_color_override("font_color", Color.ORANGE_RED)
		Enums.KeyState.GOOD:
			$Text.text = "good"
			$Text.add_theme_color_override("font_color", Color.LIME_GREEN)
		Enums.KeyState.GREAT:
			$Text.text = "Great"
			$Text.add_theme_color_override("font_color", Color.DARK_GREEN)
		Enums.KeyState.EXCELLENT:
			$Text.text = "Excellent!"
			$Text.add_theme_color_override("font_color", Color.GOLD)
			
	$Animator.play("activate")

