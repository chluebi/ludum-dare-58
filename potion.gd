extends Area2D

@export var type: Constants.potion_type
func _ready() -> void:
	set_potion_type(type)
	body_entered.connect(on_pickup)

func set_potion_type(t: Constants.potion_type):
	type = t
	var x = type * 4.0
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
	set_potion_type(randi_range(0, Constants.potion_type.FINAL - 1))

func on_pickup(body):
	if body.has_method("on_potion_pickup"):
		body.on_potion_pickup(self)
