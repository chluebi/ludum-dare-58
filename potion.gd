extends Area2D

enum potion_type {
	orange, yellow, green, blue, rainbow, purple, pink,
	FINAL
}
@export var current_type: potion_type
func _ready() -> void:
	set_potion_type(current_type)
	body_entered.connect(on_pickup)

func set_potion_type(t: potion_type):
	current_type = t
	var x = current_type * 4.0
	#if current_type == potion_type.red:
		#x = 0.0
	#elif current_type == potion_type.yellow:
		#x = 0.0
	#elif current_type == potion_type.yellow:
		#x = 0.0
	#elif current_type == potion_type.yellow:
		#x = 0.0
	#elif current_type == potion_type.yellow:
		#x = 0.0
	#elif current_type == potion_type.yellow:
		#x = 0.0
	$sprite.region_rect = Rect2(x, 0, 5.0, 8.0)

func set_random_type():
	set_potion_type(randi_range(0, potion_type.FINAL - 1))

func on_pickup(body):
	if body.has_method("on_potion_pickup"):
		body.on_potion_pickup(self)
