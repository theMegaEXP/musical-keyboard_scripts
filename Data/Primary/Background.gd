class_name Background

enum Anim {
	NONE,
	RESET,
	SET_COLOR,
	FADE_COLOR,
	PULSE_COLOR,
	PULSE,
}

enum AnimProperty {
	COLOR,
	DURATION,
	AMOUNT
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
		# Covert Color objects to HTML color strings
		var values = []
		for value in property_values:
			if value is Color:
				value = value.to_html()
			values.append(value)
		
		return {
			'animation': animation,
			'property_types': property_types,
			'property_values': values
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
	
	
