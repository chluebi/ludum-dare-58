extends Control



const POTION_SCENE = preload("res://potion.tscn")


func setup(slot_index: int, is_empty: bool, potion_type: Constants.potion_type, selected: bool) -> void:
	var selector: AnimatedSprite2D = $Selector
	
	if selected:
		selector.show() 
		selector.play("selected")
	else:
		selector.stop()
		selector.play("default")
	
	if !is_empty:
		var potion = POTION_SCENE.instantiate()
		
		add_child(potion)
		potion.position = position
		potion.set_potion_type(potion_type)
		
		potion.scale = Vector2(0.9, 0.9)
	
