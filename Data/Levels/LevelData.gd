class_name LevelData

static func get_level_by_file(file: String) -> Dictionary:
	for category in levels.values():
		for level in category:
			if level['file'] == file:
				return level
	return {
		'error': str(file) + ' does not exist.'
	}
	
# Add 2 new levels

const levels = {
	'tests': [
		{
			'name': 'Level 1',
			'tempo': 128,
			'duration': 0,
			'thumbnail': null,
			'file': '',
			'square_texture': '',
			'modes': {
				'easy': {
					'difficulty': 8,
					'sequence': '',
				},
				'medium': {
					'difficulty': 8,
					'sequence': '',
				},
				'hard': {
					'difficulty': 8,
					'sequence': '',
				},
			},
		},
	],
	
	'main': [
		
	],
	
	'electrospekt': [
		{
			'name': 'The Beast',
			'file': 'The Beast.ogg',
			'tempo': 127,
			'notes_per_beat': 4,
			'notes_per_measure': 4,
			'duration': 221.10,
			'song_demo_start': 71.81,
			'db_reduction': 9, 
			'thumbnail': null,
			'square_texture': '',
			'modes': {
				'hard': {
					'difficulty': 7,
					'sequence': 'A_B_C_D_E_F_G_',
					'fall_multiplier': 20,
				}
			}
		},
		{
			'name': 'Airborne',
			'file': 'Airborne.ogg',
			'tempo': 128,
			'notes_per_beat': 4,
			'notes_per_measure': 4,
			'duration': 210.23,
			'song_demo_start': 82.50,
			'db_reduction': 4, 
			'thumbnail': null,
			'square_texture': '',
			'modes': {
				'hard': {
					'difficulty': 7,
					'sequence': 'A_B_C_D_E_F_G_',
					'fall_multiplier': 20,
				}
			}
		},
		{
			'name': 'The Plague',
			'file': 'The-Plague.ogg',
			'tempo': 124,
			'notes_per_beat': 4,
			'notes_per_measure': 4,
			'duration': 226.45,
			'song_demo_start': 105.48,
			'db_reduction': 9, 
			'thumbnail': null,
			'square_texture': '',
			'modes': {

			},
		},
		{
			'name': 'Shock',
			'file': 'Shock--remix.ogg',
			'tempo': 126,
			'notes_per_beat': 4,
			'notes_per_measure': 4,
			'duration': 163.81,
			'song_demo_start': 38.09,
			'db_reduction': 9, 
			'thumbnail': null,
			'square_texture': '',
			'modes': {

			},
		},
	],
	
	'other': [
		
	],
}
