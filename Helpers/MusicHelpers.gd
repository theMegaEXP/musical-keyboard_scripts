class_name MusicHelpers

static func calc_note_time(tempo: float, notes_per_beat: int = 4) -> float:
	return 60.0 / tempo / notes_per_beat

static func volume_range_to_db_reduction(vol: int) -> float:
	if vol < 0: vol = 0
	if vol > 10: vol = 10
	
	if vol == 0: return -80
	return -20 + (float(vol) / 10) * 20
