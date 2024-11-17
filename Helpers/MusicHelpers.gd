class_name MusicHelpers

static func calc_note_time(tempo: float, notes_per_beat: int = 4) -> float:
	return 60.0 / tempo / notes_per_beat
