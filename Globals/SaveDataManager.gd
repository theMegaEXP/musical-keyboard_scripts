# class is global variable named "SaveDataManager"
extends Node

const NAME = "SaveDataManager"
const SAVE_DATA_PATH = "res://SaveData/"
const LEVEL_STATS_FILE = "level-stats.json"
const SETTINGS_FILE = "settings.json"

const default_settings = {
	'music_volume': 10,
	'sfx_volume': 10,
	'framerate': 120,
	'enable_gridlines': false,
}

const default_stats = {
	'completed': false,
	'high_score': 0,
	'rank': LevelData.Rank.NONE,
	'percent': 0
}

const default_levels = {
	'the_beast': {'hard': {}},
	'glow': {'extreme': {}},
	'the_plague': {'easy': {}},
	'shock': {'hard': {}},
}



func _enter_tree():
	validate_level_stats()
	validate_settings()



# Level stats related methods

func get_all_level_stats() -> Dictionary: # Retrives all stats
	var path = SAVE_DATA_PATH + LEVEL_STATS_FILE
	var level_stats = read_json(path)
	return level_stats
	
func get_level_stats(level: String, difficulty: LevelData.Difficulty) -> Dictionary: # Retrives the stats from a specific level and difficulty
	var level_stats = get_all_level_stats()
	var difficulty_string = LevelData.difficulty_enum_to_string(difficulty)
	return level_stats[level][difficulty_string]
	
func save_level_stats(level_stats: Dictionary) -> void: # Saves all stats
	assert(Helpers.dict_keys_match(level_stats, default_levels), "Level stats dictionary does not match default keys.")
	for level_key in level_stats.keys():
		assert(Helpers.dict_keys_match(level_stats[level_key], default_levels[level_key]))
		for diff_key in level_stats[level_key].keys():
			assert(Helpers.dict_keys_match(level_stats[level_key][diff_key], default_stats))
	write_json(SAVE_DATA_PATH + LEVEL_STATS_FILE, level_stats)
	
func update_level_stats(level: String, difficulty: LevelData.Difficulty, stats: Dictionary) -> void: # Saves stast of a specific level and difficulty
	var level_stats = get_all_level_stats()
	var difficulty_string = LevelData.difficulty_enum_to_string(difficulty)
	level_stats[level][difficulty_string] = stats
	save_level_stats(level_stats)
	


# Settings related methods

func get_settings() -> Dictionary:
	var path = SAVE_DATA_PATH + SETTINGS_FILE
	var settings = read_json(path)
	return settings
	
func save_settings(settings: Dictionary) -> void:
	assert(Helpers.dict_keys_match(settings, default_settings), "Settings dictionary does not match default keys.")
	write_json(SAVE_DATA_PATH + SETTINGS_FILE, settings)
	


# Data validation methods

func validate_dir() -> bool:
	var dir_exists: bool = DirAccess.dir_exists_absolute(SAVE_DATA_PATH)
	if not dir_exists:
		DirAccess.make_dir_recursive_absolute(SAVE_DATA_PATH)
		print("Directory " + SAVE_DATA_PATH + " did not exist, so this directory has been created.")
	return dir_exists
	
func validate_file(file: String) -> bool:
	validate_dir()
	var path = SAVE_DATA_PATH + file
	var file_exists: bool = FileAccess.file_exists(path)
	if not file_exists:
		create_json(path)
		print("File " + file + " in the " + SAVE_DATA_PATH + " did not exist, so this file has been created.")
	return file_exists
	
func validate_settings() -> bool:
	validate_file(SETTINGS_FILE)
	var path = SAVE_DATA_PATH + SETTINGS_FILE
	var settings = read_json(path)
	var modification_made: bool = false
	
	# Validate keys
	if not Helpers.dict_keys_match(settings, default_settings): 
		write_json(path, default_settings) # Set settings to default data
		print("The settings file located in " + path + " did not contain the correct information, so the data has been reset to its default values.")
		return false

	# Validate values
	var validate_key: Callable = func(key: String): 
		settings[key] = default_settings[key]
		print("Setting '" + key + "' did have have the correct value, so it was given its default value.")
		modification_made = true
	
	if typeof(settings.music_volume) != TYPE_FLOAT or int(settings.music_volume) < 0 or int(settings.music_volume) > 10:
		validate_key.call('music_volume')
	if typeof(settings.sfx_volume) != TYPE_FLOAT or int(settings.sfx_volume) < 0 or int(settings.sfx_volume) > 10:
		validate_key.call('sfx_volume')
	if typeof(settings.framerate) != TYPE_FLOAT or int(settings.framerate) not in [30, 60, 120, 240]:
		validate_key.call('framerate')
	if typeof(settings.enable_gridlines) != TYPE_BOOL:
		validate_key.call('enable_gridlines')
	
	if modification_made:
		write_json(path, settings)
	return modification_made
	
	
func validate_level_stats() -> bool:
	validate_file(LEVEL_STATS_FILE)
	var path: String = SAVE_DATA_PATH + LEVEL_STATS_FILE
	var data: Dictionary = read_json(path)
	var modification_made: bool = false
	
	# Validate level keys
	for level_key in data.keys(): # Remove unwanted keys
		if level_key not in default_levels:
			data.erase(level_key)
			print("Level '" + level_key + "' removed since it is not an accepted level name.")
			modification_made = true
	for level_key in default_levels.keys(): # Add needed keys and correct any incorrect values
		if not data.has(level_key): # Add level key with default values
			data[level_key] = default_levels[level_key].duplicate()
			for diff_key in data[level_key].keys(): 
				data[level_key][diff_key] = default_stats
			print("Level '" + level_key + "' has been added to " + LEVEL_STATS_FILE + " since it did not exist.")
			modification_made = true
		else: # Validate difficulties of levels
			for diff_key in data[level_key]: # Remove unwanted keys
				if diff_key not in LevelData.DIFFICULTY_STRINGS:
					data[level_key].erase(diff_key)
					print("Difficulty '" + diff_key + "' has been removed from level '" + level_key + "' since it is not a valid difficulty.")
					modification_made = true
			for diff_key in default_levels[level_key].keys(): # Add needed keys and correct any incorrect values
				if not data[level_key].has(diff_key):
					data[level_key][diff_key] = default_stats
					print("Difficulty '" + diff_key + "' was not included in level '" + level_key + "', so it has been added to the level.")
					modification_made = true
				else: # Validate stats of level difficulty
					var stats = data[level_key][diff_key]
					if not Helpers.dict_keys_match(stats, default_stats) \
					or typeof(stats.completed) != TYPE_BOOL \
					or typeof(stats.high_score) != TYPE_FLOAT or int(stats.high_score < 0) \
					or typeof(stats.rank) != TYPE_FLOAT or int(stats.rank) < 0 or int(stats.rank) >= LevelData.Rank.size() \
					or typeof(stats.percent) != TYPE_FLOAT or int(stats.percent) < 0 or int(stats.percent) > 100:
						data[level_key][diff_key] = default_stats
						print("A value of a stat in level '" + level_key + "', difficulty '" + diff_key + "', was not of the correct type or value, so the stats of this level and difficulty have been reset.")
						modification_made = true
	
	if modification_made:
		write_json(path, data)
	return modification_made



# JSON read/write methods

func write_json(path: String, json: Dictionary) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	var text = JSON.stringify(json)
	file.store_string(text)
	file.close()
	
func read_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text()) # Gives error warning if parsed file is empty or failed. This error can be ignored.
	file.close()
	return parsed if parsed else {}
	
func create_json(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.close()
		print("File created at: " + path)
	else:
		print ("Failed to create file at: " + path)
	
