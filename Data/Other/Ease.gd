class_name Ease

enum EASE {
	LINEAR,
	OUT,
	IN,
	IN_OUT,
	OUT_IN,
}

static func get_value(ease: EASE) -> float:
	match ease:
		EASE.LINEAR: return 1
		EASE.OUT: return 0.5
		EASE.IN: return 2
		EASE.IN_OUT: return -0.5
		EASE.OUT_IN: return -2
	return 1
