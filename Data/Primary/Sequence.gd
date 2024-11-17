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
