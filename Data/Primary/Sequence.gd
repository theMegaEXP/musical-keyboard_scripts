class_name Sequence

class Point:
	
	var squares: Array[Square.Instance]
	var camera_animations: Array[Camera.Instance]
	var background_animation: Background.Instance
	
	func _init(
		squares: Array[Square.Instance] = [],
		camera_animations: Array[Camera.Instance] = [],
		background_animation: Background.Instance = Background.Instance.new()
	) -> void:
		self.squares = squares
		self.camera_animations = camera_animations
		self.background_animation = background_animation
		
	func to_dict() -> Dictionary:
		var dict_squares = []; for square in squares: dict_squares.append(square.to_dict())	
		var dict_camera_animations = []; for camera_animation in camera_animations: dict_camera_animations.append(camera_animation.to_dict())
		return {
			'squares': dict_squares,
			'camera_animations': dict_camera_animations,
			'background_animation': background_animation.to_dict(),
		}
		
static func sequence_to_json(sequence: Array[Point]) -> JSON:
	var dict = []
	var json = JSON.new()
	for point: Point in sequence:
		dict.append(point.to_dict()) 
	json.data = dict
	return json
	
static func json_to_sequence(json: JSON) -> Array[Point]:
	var dict = json.data
	var sequence: Array[Point] = []
	for point in dict:
		var squares: Array[Square.Instance] = []
		for square_dict in point['squares']:
			squares.append(Square.dict_to_instance(square_dict))
		
		var camera_animations: Array[Camera.Instance] = []
		for camera_animation_dict in point['camera_animations']:
			camera_animations.append(Camera.dict_to_instance(camera_animation_dict))
			
		var background_animation := Background.dict_to_instance(point['background_animation'])
		
		var sequence_point = Point.new(
			squares,
			camera_animations,
			background_animation,
		)
		sequence.append(sequence_point)
		
	return sequence


static func count_squres(sequence: Array[Point]) -> int:
	var count: int = 0
	for point: Point in sequence:
		count += point.squares.size()
	return count
	
static func calc_rank(good_hits: int, total_squres: int) -> LevelData.Rank:
	var percent: int = int((float(total_squres) / good_hits) * 100)
	if percent >= 99: return LevelData.Rank.S_PLUS
	elif percent >= 97: return LevelData.Rank.S
	elif percent >= 95: return LevelData.Rank.A
	elif percent >= 92: return LevelData.Rank.B
	elif percent >= 85: return LevelData.Rank.C
	else: return LevelData.Rank.D
	
static func compare_ranks(rank1: LevelData.Rank, rank2: LevelData.Rank) -> bool: # Checks whether the first rank is better than the second rank.
	var rank1_str = LevelData.rank_enum_to_string(rank1)
	var rank2_str = LevelData.rank_enum_to_string(rank2)
	return LevelData.RANK_STRINGS.find(rank1_str) < LevelData.RANK_STRINGS.find(rank2_str) # rank1 should be less than rank2 for rank1 to be the higher rank
	
