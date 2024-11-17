extends PopupPanel

signal closed ## Emitted when the close button is pressed.
signal updated(sequence: String) ## Emitted when the update button is pressed. Also give the sequence as a string.

var sequence: String = "":
	set(seq):
		sequence = seq
		%SequenceTextEdit.text = sequence

func _ready():
	%WarningLabel.text = ""

func set_sequence(new_sequence: String):
	sequence = new_sequence

func _on_text_edited():
	sequence = %SequenceTextEdit.text

func _on_copy_pressed():
	DisplayServer.clipboard_set(sequence)

func _on_paste_pressed():
	sequence = DisplayServer.clipboard_get()
	
func _on_update_button_pressed():
	hide()
	%WarningLabel.text = ""
	updated.emit(sequence)
	
func _on_close_button_pressed():
	hide()
	%WarningLabel.text = ""
	closed.emit()



