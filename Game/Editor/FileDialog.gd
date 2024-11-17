extends FileDialog

@onready var vbox = get_vbox()

func _ready():
	# Remove the top section of the dialog
	vbox.get_child(0).visible = false
	
	# Change the label text
	vbox.get_child(1).text = "Choose a Song"
	
	# Remove the file name and type section
	var child3 = vbox.get_child(3)
	for child in child3.get_children():
		child.visible = false

