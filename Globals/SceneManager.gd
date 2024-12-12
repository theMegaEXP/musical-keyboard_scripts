# class is global variable named "SceneManager"
extends Node

const STAGE_PATH = "res://Scenes/Game/Stage.tscn"
const NAME = "SceneManager"
const GLOBAL_NAMES = ["SceneManager", "SaveDataManager", "SettingsManager"]

@onready var root = get_tree().root ## The root of the tree. Same as using [get_tree().root].
@onready var pause_menu = preload("res://Scenes/Menu/PauseMenu.tscn")
@onready var main_menu = preload("res://Scenes/Menu/LevelSelect.tscn")
@onready var settings_menu = preload("res://Scenes/Menu/SettingsMenu.tscn")
@onready var level_complete_menu = preload("res://Scenes/Menu/LevelComplete.tscn")
var pause_menu_inst = null
var settings_menu_inst = null
var cur_level_data = {
	'name': null,
	'difficulty': null,
	'keyboard_style': null,
}

func load_level(level_name: String, difficulty: LevelData.Difficulty, keyboard_style: Keys.Row):
	var stage: Stage = load(STAGE_PATH).instantiate()
	var data: Dictionary =  LevelData.levels[level_name]
	var mode: Dictionary = data.modes[LevelData.difficulty_enum_to_string(difficulty)]
	
	cur_level_data.name = level_name
	cur_level_data.difficulty = difficulty
	cur_level_data.keyboard_style = keyboard_style
	
	# set Stage properties
	stage.song = load(LevelData.SONGS_PATH + data.song_file)
	# !figure out how to chagne song volume!
	stage.tempo = data.tempo
	stage.notes_per_beat = data.notes_per_beat
	stage.note_fall_time_multiplier = mode.fall_multiplier
	stage.sequence_raw = load(LevelData.LEVELS_PATH + mode.sequence_file)
	stage.keyboard_style = keyboard_style
	
	# change to scene
	change_scene_to_node(stage)
	
func change_scene_to_node(node: Node):
	await get_tree().process_frame
	for scene: Node in root.get_children():
		if scene.name not in GLOBAL_NAMES:
			root.remove_child(scene)
	root.add_child(node)
	get_tree().current_scene = node

func to_level_complete():
	change_scene_to_node(level_complete_menu.instantiate())

func to_main_menu():
	nullify_cur_level_data()
	change_scene_to_node(main_menu.instantiate())
	
func restart_level():
	load_level(cur_level_data.name, cur_level_data.difficulty, cur_level_data.keyboard_style)
	
func nullify_cur_level_data(): # currently unused
	for key in cur_level_data.keys():
		cur_level_data[key] = null
		
func show_settings():
	if settings_menu_inst: return
	settings_menu_inst = settings_menu.instantiate()
	root.add_child(settings_menu_inst)
	
func hide_settings():
	if not settings_menu_inst: return
	root.remove_child(settings_menu_inst)
	settings_menu_inst = null
	
func pause():
	if pause_menu_inst: return
	get_tree().paused = true
	pause_menu_inst = pause_menu.instantiate()
	add_child(pause_menu_inst)
	
func unpause():
	if not pause_menu_inst: return
	get_tree().paused = false
	remove_child(pause_menu_inst)
	pause_menu_inst = null
