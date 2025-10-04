extends Area2D


const SPEED = 800.0
var direction = Vector2(1.0, 0)
func _ready() -> void:
	body_entered.connect(on_collision)
	
func _process(delta: float) -> void:
	position += direction * SPEED * delta
	
func on_collision(body):
	print("collision with", body)
