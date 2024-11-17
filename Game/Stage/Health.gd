extends ProgressBar

## The health of the player
@export var max_health: int = 100
var health = max_health

signal on_health_depleted

func increase_health(amount: float = 1):
	health += amount
	update_health()
	
func decrease_health(amount: float = 8):
	health -= amount
	update_health()
	
func update_health():
	print(health)
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
		on_health_depleted.emit()
		
func change_color(color: Color):
	print(color)
	var stylebox = get_theme_stylebox("fill")
	stylebox.bg_color = color
	print(stylebox.bg_color)
		
