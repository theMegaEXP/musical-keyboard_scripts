extends ProgressBar

const DEFAULT_INCREASE = 1.0
const DEFAULT_DECREASE = 8.0

## The health of the player
@export_range(0, 1000) var max_health: int = 100
var health = max_health

signal health_depleted

func _ready():
	update_health() # Make health color reset when level changes

func increase_health(amount: float = DEFAULT_INCREASE):
	health += amount
	update_health()
	
func decrease_health(amount: float = DEFAULT_DECREASE):
	health -= amount
	update_health()
	
func update_health():
	if health <= 15:
		change_color(Color.RED)
	elif health <= 40:
		change_color(Color.ORANGE)
	else:
		change_color(Color.WHITE)
	
	if health > max_health:
		health = max_health
		
	if health > 0:
		value = health
	else:
		value = 0
		health_depleted.emit()
		
func change_color(color: Color):
	var stylebox = get_theme_stylebox("fill")
	stylebox.bg_color = color
		
