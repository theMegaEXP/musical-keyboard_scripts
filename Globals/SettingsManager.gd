# class is global variable named "SettingsManager"
extends Node

const NAME = "SettingsManager"

@onready var music_bus := AudioServer.get_bus_index("Music") 
@onready var sfx_bus := AudioServer.get_bus_index("SFX")

func _ready():
	var settings = SaveDataManager.get_settings()
	set_music_volume(settings.music_volume)
	set_sfx_volume(settings.sfx_volume)
	set_framerate(settings.framerate)

func set_music_volume(vol: int) -> void:
	var db = MusicHelpers.volume_range_to_db_reduction(vol)
	AudioServer.set_bus_volume_db(music_bus, db)
	
func set_sfx_volume(vol: int) -> void:
	var db = MusicHelpers.volume_range_to_db_reduction(vol)
	AudioServer.set_bus_volume_db(sfx_bus, db)
	
func set_framerate(fps: int) -> void:
	Engine.max_fps = fps
	
func gridlines_enabled() -> bool:
	return SaveDataManager.get_settings().enable_gridlines
