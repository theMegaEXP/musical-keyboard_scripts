extends Control

@export var song: AudioStream
@export var db_reduction: float = 7
@export var tempo: int = 128
@export var notes_per_beat: int = 4
@export var beats_per_measure: int = 4
@export var note_spacing: int = 32

var song_offset: float = 0
var notes_per_measure: int
var measure_count: int

func _enter_tree():
	measure_count = (ceil(song.get_length()) / 60) * tempo / 4
	notes_per_measure = notes_per_beat * beats_per_measure
	%Measures.measures = measure_count
	%AudioLine.measures = measure_count
	%AudioLine.tempo = tempo
	%NoteGrid.grid_length = measure_count * notes_per_measure
	
func _ready():
	$SongPlayer.stream = song
	$SongPlayer.volume_db = -db_reduction
	
func _on_edit_sequence_button_pressed():
	$SequenceStringPopup.set_sequence(str(Sequence.sequence_to_json(%NoteGrid.get_sequence()).data))
	$SequenceStringPopup.show()
	
func _on_button_pressed():
	$FileDialog.popup()
	
func _on_play_button_pressed():
	$SongPlayer.play(song_offset)
	%AudioLine.stop_animation()
	%AudioLine.play_animation()

func _on_stop_button_pressed():
	$SongPlayer.stop()
	%AudioLine.stop_animation()
	
func _on_skip_backward_button_pressed():
	%AudioLine.move_backward(notes_per_measure)
	
func _on_skip_forward_button_pressed():
	%AudioLine.move_forward(notes_per_measure)
	
func _on_audio_line_repositioned(x: float):
	_on_stop_button_pressed()
	song_offset = (x / note_spacing) / (measure_count * notes_per_measure) * song.get_length()

func _on_sequence_string_popup_updated(sequence: String):
	%NoteGrid.set_sequence(Sequence.json_to_sequence(Helpers.str_to_json(sequence)))
	

func _on_file_dialog_file_selected(path: String):
	var file = path.split('/')[-1]
	var data = LevelData.get_level_by_file(file)
	
	if data.has('error'):
		push_error('File with path name ' + str(file) + ' could not be found.')
		return
		
	song = load(path)
	db_reduction = data['db_reduction']
	tempo = data['tempo']
	notes_per_beat = data['notes_per_beat']
	notes_per_measure = data['notes_per_measure']
	song_offset = 0
	
	_enter_tree()
	_ready()
	
	%NoteGrid.reset()
	%AudioLine.reset()
	%Measures.reset()
	

func _on_show_controls_toggled(toggled_on: bool):
	%ControlsContainer.visible = toggled_on
