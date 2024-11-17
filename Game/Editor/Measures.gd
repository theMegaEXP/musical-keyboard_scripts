extends Control

## The total amount of measures to be displayed
@export var measures: int = 4

## The amount of notes per measure
@export var notes_per_measure: int = 16

## The width of each tick
@export var tick_width: float = 4

## The height of the tick on each measure afer the $Line size.y. Will be decreased by 4 pixels on other tick iterations.
@export var tick_height: float = 12:
	set(val):
		if val < 9:
			tick_height = 9
		else:
			tick_height = val

## The distance in pixels for each note to be placed.
@export var note_spacing: float = 32

func reset():
	for child in get_children():
		if child.name != "Line":
			child.queue_free()
	_ready()

func _ready():
	$Line.size.x = note_spacing * notes_per_measure * measures
	generate_ticks()

func generate_ticks():
	for i in measures:
		var number = Label.new()
		number.text = str(i + 1)
		number.position = Vector2((note_spacing * notes_per_measure * i) - 3, 0)
		add_child(number)
		
		for j in notes_per_measure:
			var tick = ColorRect.new()
			if j == 0:
				tick.size = Vector2(tick_width, tick_height)
			elif j % 4 == 0:
				tick.size = Vector2(tick_width, tick_height - 4)
			else:
				tick.size = Vector2(tick_width, tick_height - 8)
			tick.position = Vector2((note_spacing * j) + (note_spacing * notes_per_measure * i), $Line.position.y + $Line.size.y)
			tick.color = $Line.color
			add_child(tick)
