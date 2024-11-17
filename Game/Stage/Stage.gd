class_name Stage
extends Node2D

@onready var key_press_state = preload("res://Scenes/Game/KeyPressState.tscn")
@onready var square_instance = preload("res://Scenes/Game/Square.tscn")
@onready var square_hold_instance = preload("res://Scenes/Game/SquareHold.tscn")

@export_category("Song")
@export var song: AudioStream ## The song that plays
@export var tempo: float = 128 ## The tempo for the song
@export var notes_per_beat: int = 4 ## The notes per beat of the song.

@export_category("Square")
@export var gap: float = 100 ## The gap in pixels between each key.
@export var offset: float = 20 ## The offset of the keys based on the Y axis of the keyboard.
@export var note_fall_time_multiplier: int = 8 ## The number of times the note_time will cycle before the note reaches its ideal location to be pressed.

@export_category("Sequence")
@export var keyboard_style = Enums.KeyboardStyle.MAIN ## The portion of the keyboard that will be used when playing.
@export var sequence_raw: JSON ## The sequence of notes to fall in relation to the tempo.

@onready var sequence: Array[Sequence.Point] = Sequence.json_to_sequence(sequence_raw)
var sequence_index: int = 0

@onready var note_time = MusicHelpers.calc_note_time(tempo, notes_per_beat)

var keys_in_play := DoublyLinkedList.new()
var keys_in_zone := DoublyLinkedList.new()
var keys_pressed := Hashset.new()

func _ready():
	set_sequence_from_style()
	
	$Background.tempo = tempo
	$Background.notes_per_beat = notes_per_beat
	
	$Camera.tempo = tempo
	$Camera.notes_per_beat = notes_per_beat
	
	$SpawnTimer.wait_time = note_time
	$SongDelayTimer.wait_time = note_time * note_fall_time_multiplier
	$SpawnTimer.start()
	$SongDelayTimer.start()

func _input(event):
	if event is InputEventKey:
		if event.pressed \
		and event.keycode in Keys.KEY_TO_KEYBOARD_CHAR \
		and not keys_pressed.contains(event.keycode):
			keys_pressed.add(event.keycode)
			key_press(Keys.KEY_TO_KEYBOARD_CHAR[event.keycode])
		elif not event.pressed \
		and keys_pressed.contains(event.keycode):
			keys_pressed.remove(event.keycode)
	
func set_sequence_from_style():
	var map
	match keyboard_style:
		Enums.KeyboardStyle.NUMROW:
			map = Keys.KEY_TO_NUMROW
		Enums.KeyboardStyle.TOPROW:
			map = Keys.KEY_TO_TOPROW
		Enums.KeyboardStyle.HOMEROW:
			map = Keys.KEY_TO_HOMEROW
		Enums.KeyboardStyle.BOTTOMROW:
			map = Keys.KEY_TO_BOTTOMROW
	
	if map != null:
		for point: Sequence.Point in sequence:
			for square_instance: Square.Instance in point.squares:
				square_instance.key = map[square_instance.key]
		
func spawn(square_data: Square.Instance):
	var key_vector = Keys.KEYBOARD_MAP[square_data.key]
	var pos = Marker2D.new()
	var new_square # Is set in if statement below
	
	# Spawn either a normal Square or a SquareHold depending on the duration
	if square_data.duration == 0:
		new_square = square_instance.instantiate()
	else:
		new_square = square_hold_instance.instantiate()
		new_square.tempo = tempo
		new_square.notes_per_beat = notes_per_beat
		new_square.set_line_height((900 / note_fall_time_multiplier) * square_data.duration) 
		new_square.connect("held", _on_key_held)
	
	new_square.data = square_data
	new_square.set_fall_time(note_time * note_fall_time_multiplier * 2, 1800)
	new_square.set_animations(square_data.fall_anim, square_data.bad_hit_anim, square_data.good_hit_anim)
	pos.position.x = (key_vector.x * gap) + (key_vector.y * -offset)
	pos.add_child(new_square)
	keys_in_play.append(new_square)
	$SpawnPosition.add_child(pos)

func key_press(key: String):
	var pressed_square
	var is_in_zone = false
	
	# Check if square is in keys_in_zone, if so then assign to pressed_square
	for area_key in keys_in_zone.to_array():
		if area_key.data.key == key:
			pressed_square = area_key
			keys_in_zone.delete(pressed_square)
			keys_in_play.delete(pressed_square)
			is_in_zone = true
			break
	
	# If pressed square is not in keys_in_zone, check if it is in keys_in_play
	if not pressed_square and not keys_in_play.is_empty():
		pressed_square = keys_in_play.pop_front()
		
	# If pressed square is not in keys_in_play, return and give the player a "bad hit"
	if not pressed_square:
		%HealthBar.decrease_health()
		%Score.reset_good_hits()
		return
	
	# If pressed square is in the zone
	if is_in_zone and pressed_square.data.key == key:
		# If the score is a SquareHold
		if pressed_square is SquareHoldObj:
			pressed_square.press()
		# If the square is a normal Square
		else:
			pressed_square.animate_success()
			%HealthBar.increase_health()
			%Score.hit(pressed_square.state)
			%NoteGoodArea.play_hit_animation()
			summon_key_press_state(pressed_square, pressed_square.state)
	# If pressed square is not in the zone
	else:
		pressed_square.animate_fail()
		%HealthBar.decrease_health()
		%Score.reset_good_hits()
		
func summon_key_press_state(active_square: CharacterBody2D, state: Enums.KeyState):
	var kps = key_press_state.instantiate()
	kps.position = Vector2(active_square.get_parent().position.x + $SpawnPosition.position.x, active_square.position.y + $SpawnPosition.position.y)
	kps.key_state = state
	add_child(kps)
	
func _on_spawn_timer_timeout():
	if sequence_index >= sequence.size():
		$SpawnTimer.stop()
		return
	var point = sequence[sequence_index]
	
	# Spawn squares
	if not point.squares.is_empty():
		for square: Square.Instance in point.squares:
			spawn(square)
			
	# Activate background animation
	if point.background_animation.animation != Background.Anim.NONE:
		$Background.play_animation(point.background_animation)
		
	# Activate camera animations
	if not point.camera_animations.is_empty():
		for anim: Camera.Instance in point.camera_animations:
			$Camera.play_animation(anim)
	
	sequence_index += 1
	
func _on_song_delay_timer_timeout():
	$MusicPlayer.stream = song
	$MusicPlayer.play()

func _zone_entered(body):
	keys_in_zone.append(body)
	
func _zone_exited(body):
	if keys_in_play.size() > 0 and keys_in_zone.contains(body):
		summon_key_press_state(body, body.state)
		keys_in_play.delete(body)
		keys_in_zone.delete(body)

func _on_key_held(body: SquareHoldObj, percent: float): 
	print("Percent: " + str(percent))
	if (percent < 0.5):
		%Score.reset_good_hits()
		summon_key_press_state(body, Enums.KeyState.MISS)
		body.animate_fail()
	else:
		%Score.hit(body.state)
		%Score.increase_score(int(percent * 10) * body.data.duration)
		summon_key_press_state(body, body.state)
		body.animate_success()
		
func _on_music_player_finished():
	pass#End game
