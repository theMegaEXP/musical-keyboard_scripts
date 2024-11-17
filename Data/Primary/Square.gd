class_name Square
extends Node

enum SquareTexture {
	BLANK,
	LINE1,
	LINE2,
	LINE3,
	LINE4,
	LINE5,
	LINE6,
	STRIPED1,
	STRIPED2,
	STRIPED3,
	STRIPED4
}

enum FallAnim {
	LINEAR,
	FAST_START,
	MID_PAUSE,
	ZONE_PAUSE,
	QUICK_PASS,
}

enum HitAnim {
	DEFAULT,
	SPIN_LEFT,
	SPIN_RIGHT,
	JUMP_LEFT,
	JUMP_RIGHT,
	SHRINK,
	#FADE,
	#BREAK,
	#EXPLODE,
}

enum Values {
	KEY,
	DURATION,
	TEXTURE,
	COLOR,
	FALL_ANIM,
	GOOD_HIT_ANIM,
	BAD_HIT_ANIM
}

class Instance:

	var key: String
	var duration: int
	var texture: SquareTexture
	var color: Color
	var fall_anim: FallAnim
	var good_hit_anim: HitAnim
	var bad_hit_anim: HitAnim

	func _init(
		key: String,
		duration: int = 0,
		texture: SquareTexture = SquareTexture.BLANK,
		color: Color = Color.WHITE,
		fall_anim: FallAnim = FallAnim.LINEAR,
		good_hit_anim: HitAnim = HitAnim.DEFAULT,
		bad_hit_anim: HitAnim = HitAnim.DEFAULT,
	) -> void:
		self.key = key
		self.duration = duration
		self.texture = texture
		self.color = color
		self.fall_anim = fall_anim
		self.good_hit_anim = good_hit_anim
		self.bad_hit_anim = bad_hit_anim
		
	func to_dict() -> Dictionary:
		return {
			'key': key,
			'duration': duration,
			'texture': texture,
			'color': color.to_html(),
			'fall_anim': fall_anim,
			'good_hit_anim': good_hit_anim,
			'bad_hit_anim': bad_hit_anim
		}
		
	func clone() -> Square.Instance:
		return Square.Instance.new(
			key,
			duration,
			texture,
			color,
			fall_anim,
			good_hit_anim,
			bad_hit_anim
		)

static func dict_to_instance(dict: Dictionary) -> Instance:
	return Instance.new(
		dict['key'],
		dict['duration'],
		dict['texture'],
		dict['color'],
		dict['fall_anim'],
		dict['good_hit_anim'],
		dict['bad_hit_anim']
	)
	
static func get_texture(texture: SquareTexture) -> Texture:
	return load("res://Resources/Textures/Square/" + Helpers.enum_string_to_camel(SquareTexture.keys()[texture]) + ".tres") 
		
