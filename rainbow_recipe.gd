extends Node2D


var brew_time = 40.0
var current_brew_time = 0.0
var brewing = false

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var bar = $Control/ProgressBar
	
	if brewing:
		current_brew_time += delta
		
		bar.show()
		bar.value = 100.0 * clampf(current_brew_time/brew_time, 0, 1)
	else:
		bar.hide()
	

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



func setup(
	ingredient1_in: bool,
	ingredient2_in: bool,
	ingredient3_in: bool,
	ingredient4_in: bool,
	ingredient5_in: bool,
	ingredient6_in: bool,
	):
	
	var ingredient1 = $Control/Ingredient1
	ingredient1.set_item_type(Constants.item_type.orange)
	ingredient1.modulate.a = 1.0 if ingredient1_in else 0.2
	
	var ingredient2 = $Control/Ingredient2
	ingredient2.set_item_type(Constants.item_type.yellow)
	ingredient2.modulate.a = 1.0 if ingredient2_in else 0.2
	
	var ingredient3 = $Control/Ingredient3
	ingredient3.set_item_type(Constants.item_type.pink)
	ingredient3.modulate.a = 1.0 if ingredient3_in else 0.2
	
	var ingredient4 = $Control/Ingredient4
	ingredient4.set_item_type(Constants.item_type.blue)
	ingredient4.modulate.a = 1.0 if ingredient4_in else 0.2
	
	var ingredient5 = $Control/Ingredient5
	ingredient5.set_item_type(Constants.item_type.purple)
	ingredient5.modulate.a = 1.0 if ingredient5_in else 0.2
	
	var ingredient6 = $Control/Ingredient6
	ingredient6.set_item_type(Constants.item_type.green)
	ingredient6.modulate.a = 1.0 if ingredient6_in else 0.2
		
	var result = $Control/Result
	result.set_item_type(Constants.item_type.rainbow)
	
	if ingredient1_in and ingredient2_in and ingredient3_in and ingredient4_in and ingredient5_in and ingredient6_in:
		brewing = true
		current_brew_time = 0
	else:
		brewing = false
