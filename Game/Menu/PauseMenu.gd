extends Control

func _input(event):
	if event.is_action_pressed('pause'):
		SceneManager.unpause()

func _on_continue_btn_pressed():
	SceneManager.unpause()

func _on_restart_btn_pressed():
	SceneManager.restart_level()
	SceneManager.unpause()

func _on_main_menu_btn_pressed():
	SceneManager.to_main_menu()
	SceneManager.unpause()

func _on_settings_btn_pressed():
	SceneManager.show_settings()
