class_name SquareStatic
extends Control

var key: String = "A":
	set(val):
		key = val
		$Label.text = val
		square_instance.key = key
var duration: int = 0:
	set(dur):
		duration = dur
		$Duration.text = str(dur)
		$Duration.visible = dur > 0
		square_instance.duration = duration
var texture: Square.SquareTexture:
	set(t):
		texture = t
		$TextureRect.texture = Square.get_texture(t)
		square_instance.texture = texture
var color: Color = Color.WHITE:
	set(col):
		color = col
		$TextureRect.modulate = col
		$Duration.add_theme_color_override("font_color", col.inverted())
		square_instance.color = color

var square_instance := Square.Instance.new(key, duration)

func _ready():
	texture = Square.SquareTexture.BLANK
	
func set_content(square: Square.Instance, defaults: Square.Instance = Square.Instance.new('A')):
	square_instance = square
	key = square.key
	duration = square.duration
	texture = square.texture
	color = square.color
	
	# Determine if animation indication should be set
	$Animation.visible = (
		square.fall_anim != defaults.fall_anim
		or square.good_hit_anim != defaults.good_hit_anim
		or square.bad_hit_anim != defaults.bad_hit_anim
	)
