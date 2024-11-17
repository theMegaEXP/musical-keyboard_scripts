extends Area2D

signal state_changed(body: CharacterBody2D, key_state: Enums.KeyState)

func play_hit_animation():
	const TRACK_INDEX = 0 
	const KEY_INDEX = 0
	var animation = $NoteGoodAnimator.get_animation('hit')
	animation.track_set_key_value(TRACK_INDEX, KEY_INDEX, %Light.energy)
	$NoteGoodAnimator.stop()
	$NoteGoodAnimator.play('hit')
	

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is CharacterBody2D and body.name != 'Square':
		return
	
	var key_state = Enums.KeyState.POOR
	match local_shape_index:
		0:
			key_state = Enums.KeyState.POOR
		1:
			key_state = Enums.KeyState.GOOD
		2:
			key_state = Enums.KeyState.GREAT
		3:
			key_state = Enums.KeyState.EXCELLENT
	body.state = key_state
	state_changed.emit(body, key_state)

func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body is CharacterBody2D and body.name != 'Square':
		return
	
	var key_state = Enums.KeyState.GREAT
	match local_shape_index:
		3:
			key_state = Enums.KeyState.GREAT
		2:
			key_state = Enums.KeyState.GOOD
		1:
			key_state = Enums.KeyState.POOR
		0: 
			key_state = Enums.KeyState.MISS
	if is_instance_valid(body):
		body.state = key_state
		state_changed.emit(body, key_state)
