extends HFlowContainer

@onready var level_display = preload("res://Scenes/Menu/LevelDisplay.tscn")

func _ready():
	for level_name in LevelData.levels.keys():
		var data = LevelData.levels[level_name]
		for mode_name in data.modes.keys():
			var mode = data.modes[mode_name]
			var stats = SaveDataManager.get_level_stats(level_name, mode.difficulty)
			var display: LevelDisplay = level_display.instantiate()
			display.level_name = level_name
			display.level_tempo = data.tempo
			display.level_duration = data.get('duration', 0)
			display.level_difficulty = mode.difficulty
			display.level_select_parent = get_parent()
			display.level_song = load(LevelData.SONGS_PATH + data.song_file)
			display.level_song_start = data.song_demo_start
			display.level_song_reduction = data.db_reduction
			display.level_thumbnail = load(LevelData.THUMBNAILS_PATH + mode.thumbnail_file)
			display.level_rank = stats.rank
			display.level_percent = stats.percent
			display.level_completed = stats.completed
			add_child(display)
			
func stop_all_audio():
	for display: LevelDisplay in get_children():
		display.get_audio_player().stop()
