extends Control





func setup(slot_index: int, is_empty: bool, potion_type: Constants.item_type, selected: bool) -> void:
	var selector: AnimatedSprite2D = $Selector
	
	if selected:
		selector.show() 
		selector.play("selected")
	else:
		selector.stop()
		selector.play("default")
	
	var potion = $potion
	if !is_empty:
		potion.visible = true
		potion.set_potion_type(potion_type)
	else:
		potion.visible = false
