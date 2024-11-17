extends PopupPanel

signal content_updated(cameras: Array[Camera.Instance], bg: Background.Instance)
signal cancelled() ## emits when context is canceled

@export var destroy_on_ok: bool = true
@export var destroy_on_cancel: bool = true

func set_cameras(camera: Array[Camera.Instance]):
	%CameraCategory.set_content(camera)

func get_cameras() -> Array[Camera.Instance]:
	return %CameraCategory.get_content()

func set_background(bg: Background.Instance):
	%BackgroundCategory.set_content(bg)

func get_background() -> Background.Instance:
	return %BackgroundCategory.get_content()
	
func _on_ok_pressed():
	content_updated.emit(get_cameras(), get_background())
	if destroy_on_ok:
		queue_free()
	
func _on_cancel_pressed():
	cancelled.emit()
	if destroy_on_cancel:
		queue_free()

func _on_reset_pressed():
	%CameraCategory.reset()
	%BackgroundCategory.reset()
