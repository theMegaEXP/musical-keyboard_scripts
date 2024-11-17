extends VBoxContainer

func _ready():
	add_sort_options()

func add_sort_options():
	var options = [
		"Difficulty Easy to Hard", 
		"Difficulty Hard to Easy", 
		"Time Shortest to Longest", 
		"Time Longest to Shortest",
	]
	for option in options:
		%SortOptions.add_item(option)

func _min_slider_changed(value):
	%MinLevelValue.text = str(value)
	if value > %MaxLevelSlider.value:
		%MaxLevelSlider.value = value


func _max_slider_changed(value):
	%MaxLevelValue.text = str(value)
	if value < %MinLevelSlider.value:
		%MinLevelSlider.value = value
