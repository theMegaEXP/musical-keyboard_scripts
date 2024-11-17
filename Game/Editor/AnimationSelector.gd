extends GridContainer

var animation_context := preload("res://Scenes/LevelEditor/AnimationContext.tscn")

var cameras: Array[Camera.Instance] = []
var bg := Background.Instance.new()

enum Icon {
	NONE,
	CAMERA,
	BACKGROUND,
	SQUARE,
	OTHER
}

func _ready():
	for icon in get_children():
		icon.visible = false
		
func _gui_input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:
		var context_menu = animation_context.instantiate()
		context_menu.connect('content_updated', _on_context_menu_updated)
		add_child(context_menu)
		context_menu.set_cameras(cameras)
		context_menu.set_background(bg)

func add_icon(icon: Icon):
	match icon:
		Icon.CAMERA:
			$Camera.visible = true
		Icon.BACKGROUND:
			$Background.visible = true
		Icon.SQUARE:
			$Square.visible = true
		Icon.OTHER:
			$Square.visible = true

func remove_icon(icon: Icon):
	match icon:
		Icon.CAMERA:
			$Camera.visible = false
		Icon.BACKGROUND:
			$Background.visible = false
		Icon.SQUARE:
			$Square.visible = false
		Icon.OTHER:
			$Square.visible = false
			
func remove_all_icons():
	$Camera.visible = false
	$Background.visible = false
	$Square.visible = false
	
func update_content(updated_cameras: Array[Camera.Instance], updated_bg: Background.Instance):
	cameras = updated_cameras
	bg = updated_bg
	add_icon(Icon.CAMERA) if not cameras.is_empty() else remove_icon(Icon.CAMERA)
	add_icon(Icon.BACKGROUND) if bg.animation != Background.Anim.NONE else remove_icon(Icon.BACKGROUND)
	
func _on_context_menu_updated(updated_cameras: Array[Camera.Instance], updated_bg: Background.Instance):
	update_content(updated_cameras, updated_bg)
