extends Control

var slot_index := 0
const POTION_SCENE = preload("res://potion.tscn")

@onready var selector: AnimatedSprite2D = $Selector # Assuming $Selector is the path to your AnimatedSprite2D
@onready var potion := POTION_SCENE.instantiate()

func _ready() -> void:
	add_child(potion)
	potion.position = position
	potion.set_potion_type(randi_range(0, 6))
	
	potion.scale = Vector2(0.9, 0.9)

func select_slot():
	selector.show() 
	selector.play("selected")

func deselect_slot():
	selector.stop()
	selector.play("default")
