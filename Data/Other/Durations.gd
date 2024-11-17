class_name Durations

enum Duration {
	ONE_NOTE,
	TWO_NOTES,
	ONE_BEAT,
	TWO_BEATS,
	ONE_MEASURE,
	TWO_MEASURES,
	FOUR_MEASURES,
}

static func get_time_from_duration(duration: Duration, note_duration: float, notes_per_beat: int = 4) -> float:
	match duration:
		Duration.ONE_NOTE: return note_duration
		Duration.TWO_NOTES: return note_duration * 2
		Duration.ONE_BEAT: return note_duration * notes_per_beat
		Duration.TWO_BEATS: return note_duration * notes_per_beat * 2
		Duration.ONE_MEASURE: return note_duration * notes_per_beat * 4
		Duration.TWO_MEASURES: return note_duration * notes_per_beat * 8
		Duration.FOUR_MEASURES: return note_duration * notes_per_beat * 16
		_: return note_duration
