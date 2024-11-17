extends Camera2D

@export var tempo: float = 128
@export var notes_per_beat: int = 4

@onready var note_duration: float = MusicHelpers.calc_note_time(tempo)

var zoom_loop_playing: bool = false
var rotation_loop_playing: bool = false

func _ready():
	position = get_viewport_rect().size / 2

func play_animation(anim: Camera.Instance):
	match anim.animation:
		Camera.Anim.IDLE:
			stop_animations()
		Camera.Anim.RESET_ALL:
			reset_all(
				Camera.get_property_value(Camera.AnimProperty.DURATION, anim), 
				Camera.get_property_value(Camera.AnimProperty.EASE, anim)
			)
		Camera.Anim.RESET_ZOOM:
			zoom_loop_playing = false
			reset_zoom(
				Camera.get_property_value(Camera.AnimProperty.DURATION, anim), 
				Camera.get_property_value(Camera.AnimProperty.EASE, anim)
			)
		Camera.Anim.RESET_ROTATION:
			rotation_loop_playing = false
			reset_rotation(
				Camera.get_property_value(Camera.AnimProperty.DURATION, anim), 
				Camera.get_property_value(Camera.AnimProperty.EASE, anim)
			)
		Camera.Anim.ZOOM:
			zoom_loop_playing = false
			zoom_to(
				Camera.get_property_value(Camera.AnimProperty.INTENSITY, anim), 
				Camera.get_property_value(Camera.AnimProperty.DURATION, anim), 
				Camera.get_property_value(Camera.AnimProperty.EASE, anim)
			)
		Camera.Anim.ROTATE:
			rotation_loop_playing = false
			rotate_to(
				Camera.get_property_value(Camera.AnimProperty.INTENSITY, anim), 
				Camera.get_property_value(Camera.AnimProperty.DURATION, anim), 
				Camera.get_property_value(Camera.AnimProperty.EASE, anim)
			)
		Camera.Anim.ZOOM_LOOP:
			zoom_loop_playing = false
			start_zoom_loop(
				Camera.get_property_value(Camera.AnimProperty.INTENSITY, anim), 
				Camera.get_property_value(Camera.AnimProperty.DURATION, anim), 
				Camera.get_property_value(Camera.AnimProperty.EASE, anim)
			)
		Camera.Anim.ROTATION_LOOP:
			rotation_loop_playing = false
			start_rotation_loop(
				Camera.get_property_value(Camera.AnimProperty.INTENSITY, anim), 
				Camera.get_property_value(Camera.AnimProperty.DURATION, anim), 
				Camera.get_property_value(Camera.AnimProperty.EASE, anim)
			)
	
func rotate_to(rotation_amount: Camera.Rotation, duration: Durations.Duration, ease: Ease.EASE):
	const TRACK_INDEX = 0
	const KEY_INDEX1 = 0
	const KEY_INDEX2 = 1
	var anim = $RotationAnimator.get_animation('rotate')
	var time = Durations.get_time_from_duration(duration, note_duration)
	var rotation_value = Camera.get_rotation_from_intensity(rotation_amount)
	var ease_value = Ease.get_value(ease)
	
	anim.set_length(time)
	anim.track_set_key_value(TRACK_INDEX, KEY_INDEX1, rotation)
	anim.track_set_key_transition(TRACK_INDEX, KEY_INDEX1, ease_value)
	anim.track_set_key_time(TRACK_INDEX, KEY_INDEX2, time)
	anim.track_set_key_value(TRACK_INDEX, KEY_INDEX2, rotation_value)
	$RotationAnimator.play('rotate')
	
func zoom_to(zoom_amount: Camera.Zoom, duration: Durations.Duration, ease: Ease.EASE):
	const TRACK_INDEX = 0
	const KEY_INDEX1 = 0
	const KEY_INDEX2 = 1
	var anim = $ZoomAnimator.get_animation('zoom')
	var time = Durations.get_time_from_duration(duration, note_duration)
	var zoom_value = Camera.get_zoom_from_intensity(zoom_amount)
	var ease_value = Ease.get_value(ease)
	
	anim.set_length(time)
	anim.track_set_key_value(TRACK_INDEX, KEY_INDEX1, zoom)
	anim.track_set_key_transition(TRACK_INDEX, KEY_INDEX1, ease_value)
	anim.track_set_key_time(TRACK_INDEX, KEY_INDEX2, time)
	anim.track_set_key_value(TRACK_INDEX, KEY_INDEX2, Vector2(zoom_value, zoom_value))
	$ZoomAnimator.play('zoom')
	
func reset_all(duration: Durations.Duration, ease := Ease.EASE.LINEAR):
	zoom_loop_playing = false
	rotation_loop_playing = false
	reset_zoom(duration, ease)
	reset_rotation(duration, ease)
	
func reset_zoom(duration: Durations.Duration, ease := Ease.EASE.LINEAR):
	const TRACK_INDEX = 0
	const KEY_INDEX1 = 0
	const KEY_INDEX2 = 1
	var anim = $ZoomAnimator.get_animation('reset')
	var time = Durations.get_time_from_duration(duration, note_duration)
	var zoom_value = zoom
	var ease_value = Ease.get_value(ease)
	
	$ZoomAnimator.stop()
	anim.set_length(time)
	anim.track_set_key_value(TRACK_INDEX, KEY_INDEX1, zoom_value)
	anim.track_set_key_transition(TRACK_INDEX, KEY_INDEX1, ease_value)
	anim.track_set_key_time(TRACK_INDEX, KEY_INDEX2, time)
	$ZoomAnimator.play('reset')
	
func reset_rotation(duration: Durations.Duration, ease := Ease.EASE.LINEAR):
	const TRACK_INDEX = 0
	const KEY_INDEX1 = 0
	const KEY_INDEX2 = 1
	var anim = $RotationAnimator.get_animation('reset')
	var time = Durations.get_time_from_duration(duration, note_duration)
	var rotation_value = rotation
	var ease_value = Ease.get_value(ease)
	
	$RotationAnimator.stop()
	anim.set_length(time)
	anim.track_set_key_value(TRACK_INDEX, KEY_INDEX1, rotation_value)
	anim.track_set_key_transition(TRACK_INDEX, KEY_INDEX1, ease_value)
	anim.track_set_key_time(TRACK_INDEX, KEY_INDEX2, time)
	$RotationAnimator.play('reset')

func start_zoom_loop(zoom_amount: Camera.Zoom, duration: Durations.Duration, ease: Ease.EASE):
	$ZoomAnimator.stop()
	zoom_loop_playing = true
	while true:
		zoom_to(zoom_amount, duration, ease)
		await $ZoomAnimator.animation_finished
		reset_zoom(duration, ease)
		await $ZoomAnimator.animation_finished
		zoom_amount = Camera.get_opposite_zoom(zoom_amount)
	
func start_rotation_loop(rotation_amount: Camera.Rotation, duration: Durations.Duration, ease: Ease.EASE):
	$RotationAnimator.stop()
	
	rotation_loop_playing = true
	while rotation_loop_playing:
		rotate_to(rotation_amount, duration, ease)
		await $RotationAnimator.animation_finished
		rotate_to(rotation_amount, duration, ease)
		await $RotationAnimator.animation_finished
		rotation_amount = Camera.get_opposite_rotation(rotation_amount)

func stop_animations():
	zoom_loop_playing = false
	rotation_loop_playing = false
	$RotationAnimator.stop()
	$ZoomAnimator.stop()
