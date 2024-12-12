class_name LevelDisplay
extends PanelContainer

@export var thumbnail: Image ## The thumbnail image for the level

@export_category("Level Information")
@export var level_name: String ## The name of the level
@export var level_duration: int ## The amount of seconds in the level/song.
@export var level_tempo: int = 120 ## The tempo of the song.
@export var level_difficulty := LevelData.Difficulty.EASY ## The difficulty of the level.
@export var level_song: AudioStream
@export var level_song_reduction: float = 0
@export var level_song_start: float = 0
@export var level_thumbnail: CompressedTexture2D

@export_category("Stats Information")
@export var level_rank: LevelData.Rank
@export_range(0, 100) var level_percent: int = 0
@export var level_completed: bool = false

@onready var easy_texture = preload("res://Resources/StyleBoxes/LevelDisplayEasyStyleBox.tres")
@onready var medium_texture = preload("res://Resources/StyleBoxes/LevelDisplayMediumStyleBox.tres")
@onready var hard_texture = preload("res://Resources/StyleBoxes/LevelDisplayHardStyleBox.tres")
@onready var extreme_texture = preload("res://Resources/StyleBoxes/LevelDisplayExpertStyleBox.tres")

var level_select_parent = null

func _ready():
	%NameLabel.text = Helpers.snake_to_capitalized(level_name)
	%DurationLabel.text = str(level_duration / 60) + ':' + str(level_duration % 60 * 0.6)
	%TempoLabel.text = str(level_tempo)
	%LevelImageTexture.texture = level_thumbnail
	%Percentage.text = str(level_percent) + '%'
	%Rank.text = LevelData.rank_enum_to_string(level_rank)
	%Checkmark.visible = level_completed
	
	$Audio.stream = level_song
	$Animator.get_animation("song_fade").track_set_key_value(0, 0, -level_song_reduction)
	
	pivot_offset = Vector2(size.x / 2, size.y / 2)
	
	set_difficulty(level_difficulty)
		
func set_difficulty(difficulty: LevelData.Difficulty):
	level_difficulty = difficulty
	match difficulty:
		LevelData.Difficulty.EASY:
			add_theme_stylebox_override("panel", easy_texture)
		LevelData.Difficulty.NORMAL:
			add_theme_stylebox_override("panel", medium_texture)
		LevelData.Difficulty.HARD:
			add_theme_stylebox_override("panel", hard_texture)
		LevelData.Difficulty.EXTREME:
			add_theme_stylebox_override("panel", extreme_texture)
			
			
func get_audio_player() -> AudioStreamPlayer:
	return $Audio
			
func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		SceneManager.load_level(level_name, level_difficulty, level_select_parent.get_keyboard_style())
			
func _on_mouse_entered():
	get_parent().stop_all_audio()
	$Animator.stop()
	$Animator.play("hovering")
	$Audio.play()
	$Audio.seek(level_song_start)
	$Audio.volume_db = -level_song_reduction
	
func _on_mouse_exited():
	$Animator.stop()
	$Animator.play("song_fade")
	await $Animator.animation_finished
	$Audio.stop()
	
