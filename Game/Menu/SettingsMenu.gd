extends Control

func _ready():
	set_settings()

func set_settings():
	var settings = SaveDataManager.get_settings()
	%Music.value = settings.get('music_volume', 10)
	%SFX.value = settings.get('sfx_volume', 10)
	%Gridlines.button_pressed = settings.get('enable_gridlines', false)
	match int(settings.framerate):
		30: %Framerate.select(0)
		60: %Framerate.select(1)
		120: %Framerate.select(2)
		240: %Framerate.select(3)
		_: %Framerate.select(2)

func update_settings():
	var settings: Dictionary = {
		'music_volume': %Music.value,
		'sfx_volume': %SFX.value,
		'framerate': int(%Framerate.get_item_text(%Framerate.selected)),
		'enable_gridlines': %Gridlines.button_pressed,
	}
	
	SettingsManager.set_music_volume(settings.music_volume)
	SettingsManager.set_sfx_volume(settings.sfx_volume)
	SettingsManager.set_framerate(settings.framerate)
	
	SaveDataManager.save_settings(settings)
	
func close():
	SceneManager.hide_settings()

func _on_back_btn_pressed():
	close()

func _on_save_btn_pressed():
	update_settings()
	close()
