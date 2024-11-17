class_name Camera

enum Anim {
	NONE,
	IDLE,
	RESET_ALL,
	RESET_ZOOM,
	RESET_ROTATION,
	ZOOM,
	ROTATE,
	ZOOM_LOOP,
	ROTATION_LOOP,
}

enum AnimProperty {
	DURATION,
	INTENSITY,
	EASE,
}

enum Zoom {
	IN_SMALL,
	IN_MEDIUM,
	IN_LARGE,
	IN_GIGANTIC,
	OUT_SMALL,
	OUT_MEDIUM,
	OUT_LARGE,
	OUT_GIGANTIC,
}

enum Rotation {
	LEFT_SMALL,
	LEFT_MEDIUM,
	LEFT_LARGE,
	RIGHT_SMALL,
	RIGHT_MEDIUM,
	RIGHT_LARGE,
}

class Instance:
	
	var animation: Anim
	var property_types: Array[AnimProperty]
	var property_values: Array
	
	func _init(
		animation: Anim = Anim.NONE,
		property_types: Array[AnimProperty] = [],
		property_values: Array = []
	) -> void:
		if property_types.size() != property_values.size():
			push_error('property_types and property_value are not the same length.')
		self.animation = animation
		self.property_types = property_types
		self.property_values = property_values
		
	func to_dict() -> Dictionary:
		return {
			'animation': animation,
			'property_types': property_types,
			'property_values': property_values
		}
		
static func ints_to_anim_properties(ints: Array) -> Array[AnimProperty]:
	var properties: Array[AnimProperty] = []
	for num in ints:
		properties.append(int(num))
	return properties

static func dict_to_instance(dict: Dictionary) -> Instance:
	return Instance.new(
		dict['animation'],
		ints_to_anim_properties(dict['property_types']),
		dict['property_values']
	)
	
static func get_zoom_from_intensity(intensity: Zoom) -> float:
	match intensity:
		Zoom.IN_SMALL: return 1.02
		Zoom.IN_MEDIUM: return 1.05
		Zoom.IN_LARGE: return 1.1
		Zoom.IN_GIGANTIC: return 1.2
		Zoom.OUT_SMALL: return 0.98
		Zoom.OUT_MEDIUM: return 0.95
		Zoom.OUT_LARGE: return 0.9
		Zoom.OUT_GIGANTIC: return 0.8
	return 1
	
static func get_rotation_from_intensity(intensity: Rotation) -> float:
	match intensity:	
		Rotation.LEFT_SMALL: return deg_to_rad(2)
		Rotation.LEFT_MEDIUM: return deg_to_rad(5)
		Rotation.LEFT_LARGE: return deg_to_rad(8)
		Rotation.RIGHT_SMALL: return deg_to_rad(-2)
		Rotation.RIGHT_MEDIUM: return deg_to_rad(-5)
		Rotation.RIGHT_LARGE: return deg_to_rad(-8)
	return 0
	
static func get_property_value(property_type: AnimProperty, camera: Instance):
	for i in camera.property_types.size():
		if camera.property_types[i] == property_type:
			return camera.property_values[i]
	return null
	
static func get_opposite_zoom(zoom: Zoom):
	var map = {
		Zoom.OUT_SMALL: Zoom.IN_SMALL,
		Zoom.OUT_MEDIUM: Zoom.IN_MEDIUM,
		Zoom.OUT_LARGE: Zoom.IN_LARGE,
		Zoom.OUT_GIGANTIC: Zoom.IN_GIGANTIC,
	}
	for key in map.keys():
		if key == zoom:
			return map[key]
		elif map[key] == zoom:
			return key
	return null
	
static func get_opposite_rotation(rotation: Rotation):
	var map = {
		Rotation.LEFT_SMALL: Rotation.RIGHT_SMALL,
		Rotation.LEFT_MEDIUM: Rotation.RIGHT_MEDIUM,
		Rotation.LEFT_LARGE: Rotation.RIGHT_LARGE,
	}
	for key in map.keys():
		if key == rotation:
			return map[key]
		elif map[key] == rotation:
			return key
	return null
	
