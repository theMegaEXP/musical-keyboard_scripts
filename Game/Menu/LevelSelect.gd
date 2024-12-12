extends Control

func get_keyboard_style() -> Keys.Row:
	return %KeyboardStyle.selected

func _on_difficulty_tabs_tab_changed(tab: int):
	if tab == 0:
		for display: LevelDisplay in %LevelDisplaysContainer.get_children():
			display.visible = true
		return
	
	for display: LevelDisplay in %LevelDisplaysContainer.get_children():
		if display.level_difficulty == tab - 1: # Uses an integer value for comparison with the enum LevelData.Difficulty
			display.visible = true
		else:
			display.visible = false


func _on_settings_btn_pressed():
	SceneManager.show_settings()

func _on_quit_btn_pressed():
	get_tree().quit()
