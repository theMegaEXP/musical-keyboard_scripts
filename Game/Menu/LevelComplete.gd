extends Control



func _on_reset_btn_pressed():
	SceneManager.restart_level()

func _on_menu_btn_pressed():
	SceneManager.to_main_menu()
