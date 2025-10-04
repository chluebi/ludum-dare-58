extends Control

var slot_index := 0

@onready var selector: AnimatedSprite2D = $Selector # Assuming $Selector is the path to your AnimatedSprite2D

func select_slot():
	selector.show() 
	selector.play("selected")

func deselect_slot():
	selector.stop()
	selector.play("default")
