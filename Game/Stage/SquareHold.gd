class_name SquareHoldObj
extends SquareObj

signal held(body: SquareHoldObj, percent: float) ## Gives a percent as a float value (0 - 1.0) for how long the key was held for

@export var tempo: int = 128
@export var notes_per_beat: int = 4

@onready var note_duration: float = MusicHelpers.calc_note_time(tempo, notes_per_beat)
@onready var hold_time: float = note_duration * data.duration

var is_held: bool = false
var is_time_exceeded: bool = false
var initial_line_height: float = 1

func _ready():
	super._ready()
	$Timer.wait_time = hold_time

func _process(_delta):
	if is_held:
		var height = initial_line_height * ($Timer.time_left / hold_time)
		$HoldHeight.scale.y = height
		$HoldHeight.position.y = -(height / 2)

func _input(event):
	# Check for key is released after being held
	if is_held \
	and event is InputEventKey \
	and not event.pressed \
	and event.keycode in Keys.KEY_TO_KEYBOARD_CHAR \
	and Keys.KEY_TO_KEYBOARD_CHAR[event.keycode] == data.key:
		if is_time_exceeded:
			held.emit(self, 1.0)
		else:
			held.emit(self, 1 - ($Timer.time_left / hold_time))
		$Timer.stop()
		$HoldHeight.visible = false
		is_held = false

func press(key: String = data.key):
	if key == data.key:
		is_held = true
		$Timer.start()
		$Animator.pause()
	else:
		held.emit(self, 0.0)

func set_line_height(height: float):
	initial_line_height = height
	$HoldHeight.scale.y = height
	$HoldHeight.position.y = -(height / 2)
	
#overridden method
func animate_fail():
	$HoldHeight.visible = false
	super.animate_fail()

func _on_timer_timeout():
	is_time_exceeded = true

