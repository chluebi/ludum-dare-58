extends Node2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var should_be_transparent = false
	var area_to_check = $Area2D
	if area_to_check:
		for body in area_to_check.get_overlapping_bodies():
			if body.is_in_group("important_entities"):
				should_be_transparent = true
				break
		
		if not should_be_transparent:
			for area in area_to_check.get_overlapping_areas():
				if area.is_in_group("important_entities"):
					should_be_transparent = true
					break
	
	var alpha_value = 1.0
	if should_be_transparent:
		alpha_value = 0.5
	$Control.modulate.a = alpha_value


func move_to(x: float, y: float):
	position = Vector2(0, -90*0.15)

func setup(result_type: Constants.item_type):
	var result = $Control/Result
	result.set_item_type(result_type)
