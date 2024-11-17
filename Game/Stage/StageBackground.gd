extends Sprite2D

@export var tempo: float = 128
@export var notes_per_beat: int = 4

@onready var note_duration: float = MusicHelpers.calc_note_time(tempo, notes_per_beat)

func play_animation(anim: Background.Instance):
	var color_before_animation_end = modulate
	$Animator.stop()
	modulate = color_before_animation_end
	
	match anim.animation:
		Background.Anim.SET_COLOR:
			set_color(anim.property_values[0])
		Background.Anim.FADE_COLOR:
			var color
			var duration
			for i in anim.property_types.size():
				if anim.property_types[i] == Background.AnimProperty.COLOR:
					color = anim.property_values[i]
				elif anim.property_types[i] == Background.AnimProperty.DURATION:
					duration = Durations.get_time_from_duration(anim.property_values[i], note_duration)
			fade_to_color(color, duration)
		Background.Anim.PULSE_COLOR:
			pulse_color(anim.property_values[0])
		Background.Anim.PULSE:
			pulse(anim.property_values[0])

#func change_texture(t: Texture):
	#texture = t

func set_color(color: Color):
	modulate = color
	
func fade_to_color(color: Color, duration: float, ease: float = 1):
	const TRACK_INDEX = 0
	const KEY_INDEX_START = 0
	const KEY_INDEX_END = 1
	var animation = $Animator.get_animation('color_fade')
	animation.set_length(duration)
	animation.track_set_key_time(TRACK_INDEX, KEY_INDEX_END, duration)
	animation.track_set_key_value(TRACK_INDEX, KEY_INDEX_START, modulate)
	animation.track_set_key_transition(TRACK_INDEX, KEY_INDEX_START, ease)
	animation.track_set_key_value(TRACK_INDEX, KEY_INDEX_END, color)
	$Animator.play('color_fade')
	
func pulse_color(color: Color):
	var duration = Durations.Duration.ONE_NOTE
	var prev_color = modulate
	fade_to_color(color, Durations.get_time_from_duration(Durations.Duration.ONE_NOTE, note_duration) / 4, 0.5)
	await $Animator.animation_finished
	fade_to_color(prev_color, Durations.get_time_from_duration(Durations.Duration.ONE_NOTE, note_duration) * 0.75, 2)
	
func pulse(amount: float):
	pulse_color(Color(modulate.r + amount, modulate.g + amount, modulate.b + amount))
