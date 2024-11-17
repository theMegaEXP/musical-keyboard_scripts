extends Control

@onready var level_display = preload("res://Scenes/Menu/LevelDisplay.tscn")

func _ready():
	for level_category in LevelData.levels.values():
		for level in level_category:
			var new_display = level_display.instantiate()
			new_display.level_name = level['name']
			new_display.level_tempo = level['tempo']
			new_display.level_duration = level.get('time', 0)
			%LevelDisplaysContainer.add_child(new_display)
		
func change_level_display_textures(difficulty: Enums.Difficulty):
	for level_display in %LevelDisplaysContainer.get_children():
		level_display.change_panel_texture(difficulty)

func _on_difficulty_tabs_tab_changed(tab):
	match tab:
		0:
			change_level_display_textures(Enums.Difficulty.EASY)
		1:
			change_level_display_textures(Enums.Difficulty.MEDIUM)
		2:
			change_level_display_textures(Enums.Difficulty.HARD)
		3:
			change_level_display_textures(Enums.Difficulty.EXPERT)
			
