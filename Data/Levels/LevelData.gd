class_name LevelData

const LEVELS_PATH = "res://Levels/"
const LEVEL_STATS_PATH = "res://Levels/level-stats.json"
const SONGS_PATH = "res://Assets/Audio/Music/"
const THUMBNAILS_PATH = "res://Assets/Images/Thumbnails/"
const DEFAULT_THUMBNAIL_FILE = "default.png"
const DIFFICULTY_STRINGS = ['easy', 'normal', 'hard', 'extreme']
const RANK_STRINGS = ['S+', 'S', 'A', 'B', 'C', 'D', 'E', 'F', '-']



# Ranks

enum Rank {
	NONE,
	S_PLUS,
	S,
	A,
	B,
	C,
	D,
	E,
	F
}

static func rank_enum_to_string(rank: Rank) -> String:
	if rank == Rank.NONE:
		return '-'
	elif rank == Rank.S_PLUS:
		return 'S+'
	else:
		return Rank.keys()[rank]
		
static func rank_string_to_enum(rank: String) -> Rank:
	match rank:
		'-': return Rank.NONE
		'S+': return Rank.S_PLUS
		'A': return Rank.A
		'B': return Rank.B
		'C': return Rank.C
		'D': return Rank.D
		'E': return Rank.E
		'F': return Rank.F
	return Rank



# Difficulties

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
	EXTREME
}

static func difficulty_enum_to_string(difficulty: Difficulty) -> String:
	match difficulty:
		Difficulty.EASY: return 'easy'
		Difficulty.NORMAL: return 'normal'
		Difficulty.HARD: return 'hard'
		Difficulty.EXTREME: return 'extreme'
	return 'none'

static func difficulty_string_to_enum(difficulty: String) -> Difficulty:
	match difficulty:
		'easy': return Difficulty.EASY
		'normal': return Difficulty.NORMAL
		'hard': return Difficulty.HARD
		'extreme': return Difficulty.EXTREME
	return Difficulty



# Level information retreval

static func get_data_by_song_file(file: String) -> Dictionary:
	for level in levels.values():
		if level.song_file == file:
			return level
	return {
		'error': str(file) + ' does not exist.'
	}
	
static func get_stats() -> Dictionary:
	return Helpers.json_path_to_dict(LEVEL_STATS_PATH)
	
static func get_data(level: String) -> Dictionary:
	return Helpers.json_path_to_dict(LEVELS_PATH + level)
	



# Level information
const levels = {
	'the_beast': {
		'song_file': 'The Beast.ogg',
		'tempo': 127,
		'notes_per_beat': 4,
		'notes_per_measure': 4,
		'duration': 221.10,
		'song_demo_start': 71.81,
		'db_reduction': 9, 
		'modes': {
			'hard': {
				'difficulty': Difficulty.HARD,
				'sequence_file': 'the-beast-test1.json',
				'fall_multiplier': 20,
				'thumbnail_file': 'default.png'
			}
		}
	},
	'airborne': {
		'song_file': 'Airborne.ogg',
		'tempo': 128,
		'notes_per_beat': 4,
		'notes_per_measure': 4,
		'duration': 210.23,
		'song_demo_start': 82.50,
		'db_reduction': 4, 
		'modes': {}
	},
	'the_plague': {
		'song_file': 'The-Plague.ogg',
		'tempo': 124,
		'notes_per_beat': 4,
		'notes_per_measure': 4,
		'duration': 226.45,
		'song_demo_start': 105.48,
		'db_reduction': 9, 
		'modes': {
			'easy': {
				'difficulty': Difficulty.EASY,
				'fall_multiplier': 20,
				'sequence_file': 'the-plague--easy.json',
				'thumbnail_file': 'the-plague--easy.png'
			}
		},
	},
	'shock': {
		'song_file': 'Shock--remix.ogg',
		'tempo': 126,
		'notes_per_beat': 4,
		'notes_per_measure': 4,
		'duration': 163.81,
		'song_demo_start': 38.09,
		'db_reduction': 9, 
		'modes': {
			'hard': {
				'difficulty': Difficulty.HARD,
				'fall_multiplier': 14,
				'sequence_file': 'shock-test1.json',
				'thumbnail_file': 'shock--hard.png'
			}
		},
	},
	'transform': {
		'song_file': 'Transform.ogg',
		'tempo': 128,
		'notes_per_beat': 4,
		'notes_per_measure': 4,
		'duration': 210.00,
		'song_demo_start': 35.62,
		'db_reduction': 1, 
		'modes': {},
	},
	'digital': {
		'song_file': 'Digital.ogg',
		'tempo': 125,
		'notes_per_beat': 4,
		'notes_per_measure': 4,
		'duration': 184.32,
		'song_demo_start': 38.40,
		'db_reduction': 9, 
		'modes': {},
	},
	'glow': {
		'song_file': 'Glow.ogg', 
		'tempo': 128,
		'notes_per_beat': 4,
		'notes_per_measure': 4,
		'duration': 182.94,
		'song_demo_start': 75.00,
		'db_reduction': 9, 
		'modes': {
			'extreme': {
				'difficulty': Difficulty.EXTREME,
				'fall_multiplier': 18,
				'sequence_file': 'glow--extreme.json',
				'thumbnail_file': 'glow--extreme.png'
			}
		},
	},
}
