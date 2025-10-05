var max_health: float
var current_health: float
var animation_timer = -1
signal death_signal
signal health_percentage

func _init(mh):
	max_health = mh
	current_health = max_health

	
func animate_damage(body: Node2D, delta):
	if animation_timer == -1:
		return
	animation_timer += delta
	if animation_timer < 0.1:
		body.modulate.g = 0.5
		body.modulate.b = 0.5
		body.scale = Vector2(0.8, 0.8)
	else:
		body.modulate.g = 1.0
		body.modulate.b = 1.0
		animation_timer = -1
		body.scale = Vector2(1, 1)


	
func take_damage(amount) -> bool:
	current_health -= amount
	animation_timer = 0
	health_percentage.emit(current_health * 1.0 / max_health)
	if current_health <= 0:
		death_signal.emit()
		return true
	return false
	
func heal_damage(amount):
	current_health += amount
	health_percentage.emit(current_health * 1.0 / max_health)
	if current_health > max_health:
		current_health = max_health
