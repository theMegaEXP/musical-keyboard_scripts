class_name SquareObj
extends CharacterBody2D

var data: Square.Instance = Square.Instance.new('B', 4, Square.SquareTexture.BLANK, Color.CYAN)
var state: Enums.KeyState = Enums.KeyState.NONE

var fall_animation = 'fall.linear'
var fail_animation = 'hit.default'
var success_animation = 'hit.default'

func _ready():
	%Letter.text = data.key
	%Sprite.texture = Square.get_texture(data.texture)
	%Sprite.modulate = data.color
	animate_fall()
	
func set_fall_time(time: float, distance: float):
	const TRACK = 0
	const KEY_PERCENTAGES = {
		'linear': [0.0, 1.0],
		'fast_start': [0.0, 0.2, 0.5, 1.0],
		'mid_pause': [0.0, 0.2, 0.5, 1.0],
		'quick_pass': [0.0, 0.5, 1.0],
		'zone_pause': [0.0, 0.5, 1.0],
	}
	
	for anim_name: String in KEY_PERCENTAGES:
		var anim: Animation = $Animator.get_animation('fall.' + anim_name)
		anim.set_length(time)
		for i: int in KEY_PERCENTAGES[anim_name].size():
			anim.track_set_key_time(TRACK, i, KEY_PERCENTAGES[anim_name][i] * time)
			anim.track_set_key_value(TRACK, i, Vector2(0, KEY_PERCENTAGES[anim_name][i] * distance))
			

func set_animations(fall_anim: Square.FallAnim, fail_anim: Square.HitAnim, success_anim: Square.HitAnim):
	fall_animation = 'fall.' + str(Square.FallAnim.keys()[fall_anim]).to_lower()
	fail_animation = 'hit.' + str(Square.HitAnim.keys()[fail_anim]).to_lower() 
	success_animation = 'hit.' + str(Square.HitAnim.keys()[success_anim]).to_lower() 

func animate_fall():
	$Animator.play(fall_animation)
	
func animate_fail():
	$Animator.pause()
	$Animator.play('fail')
	$Animator.play(fail_animation)
	$SFXPlayer.play()
	
func animate_success():
	$Animator.pause()
	$Animator.play('success')
	$Animator.play(success_animation)
	
func _on_animator_animation_finished(_anim_name):
	# Delete itself and the parent position node
	get_parent().queue_free()
