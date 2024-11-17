extends PanelContainer

## The thumbnail image for the level
@export var thumbnail: Image
## The name of the level
@export var level_name: String
## The difficulty of the level from 1-10
@export_range(1, 10) var level_difficulty: int
## The amount of seconds in the level/song.
@export var level_duration: int
## The tempo of the song.
@export var level_tempo: int

@onready var easy_texture = preload("res://Resources/StyleBoxes/LevelDisplayEasyStyleBox.tres")
@onready var medium_texture = preload("res://Resources/StyleBoxes/LevelDisplayMediumStyleBox.tres")
@onready var hard_texture = preload("res://Resources/StyleBoxes/LevelDisplayHardStyleBox.tres")
@onready var expert_texture = preload("res://Resources/StyleBoxes/LevelDisplayExpertStyleBox.tres")

func _ready():
	%NameLabel.text = level_name
	%DurationLabel.text = str(level_duration / 60) + ':' + str(level_duration % 60 * 0.6)
	%TempoLabel.text = str(level_tempo)
	
	for i in level_difficulty - 1:
		%StarsContainer.add_child(%StarIcon.duplicate())
		
	change_panel_texture(Enums.Difficulty.EASY)
		
func change_panel_texture(difficulty: Enums.Difficulty):
	match difficulty:
		Enums.Difficulty.EASY:
			add_theme_stylebox_override("panel", easy_texture)
		Enums.Difficulty.MEDIUM:
			add_theme_stylebox_override("panel", medium_texture)
		Enums.Difficulty.HARD:
			add_theme_stylebox_override("panel", hard_texture)
		Enums.Difficulty.EXPERT:
			add_theme_stylebox_override("panel", expert_texture)
			
func _on_mouse_entered():
	$Animator.play("hovering")
	
func _on_mouse_exited():
	$Animator.stop()
