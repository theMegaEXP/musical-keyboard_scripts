extends Control

## When the position is changed by the user this signal will give the x position. Does not include animation position changes.
signal repositioned(x: float)

## The tempo of the song
@export var tempo: int = 128

## The total amount of measures in the song
@export var measures: int = 10

## The length in pixels of each note
@export var note_spacing: int = 32

## The amount of notes per measure
@export var notes_per_measure: int = 16

@onready var song_duration: float = (float(measures * 4) / tempo) * 60
var start_pos: float = 0
@onready var end_pos: float = float(measures * note_spacing * notes_per_measure)
var is_animation_playing: bool = false

func reset():
	song_duration = (float(measures * 4) / tempo) * 60
	end_pos = float(measures * note_spacing * notes_per_measure)
	stop_animation()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_in_node():
		stop_animation()
		start_pos = round(get_local_mouse_position().x / note_spacing) * note_spacing
		if start_pos >= end_pos:
			start_pos = end_pos - notes_per_measure
		$ColorRect.position.x = start_pos
		repositioned.emit(start_pos)
	elif event.is_action_pressed("ui_up"):
		if not is_animation_playing:
			play_animation()
		else:
			stop_animation()

func play_animation():
	var animation = $Animator.get_animation("play")
	var duration = song_duration - (start_pos / note_spacing / notes_per_measure * 4 / tempo * 60)
	
	# First property is the track index
	# Second property is the key index
	animation.track_set_key_value(0, 0, Vector2(start_pos, 0))
	animation.track_set_key_value(0, 1, Vector2(end_pos, 0))
	animation.set_length(duration)
	animation.track_set_key_time(0, 1, duration)
	
	$Animator.play("play")
	is_animation_playing = true
	
func stop_animation():
	$Animator.stop()
	$ColorRect.position.x = start_pos
	is_animation_playing = false
	
func move_forward(spaces: int):
	if start_pos + (spaces * note_spacing) < end_pos - note_spacing:
		start_pos += (spaces * note_spacing)
	else:
		start_pos = end_pos - note_spacing
	$ColorRect.position.x = start_pos
	repositioned.emit(start_pos)
	
func move_backward(spaces: int):
	if start_pos - (spaces * note_spacing) > 0:
		start_pos -= (spaces * note_spacing)
	else:
		start_pos = 0
	$ColorRect.position.x = start_pos
	repositioned.emit(start_pos)
	
	
func mouse_in_node():
	var local_mouse_pos = get_local_mouse_position()
	if local_mouse_pos.x >= 0 and local_mouse_pos.x <= size.x and local_mouse_pos.y >= 0 and local_mouse_pos.y <= size.y:
		return true
	return false

