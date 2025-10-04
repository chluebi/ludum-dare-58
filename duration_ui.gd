extends CanvasLayer

const POTION_BAR_SCENE = preload("res://potion_bar.tscn")

@onready var container: VBoxContainer = $Anchor/DurationsContainer

func _ready() -> void:
	pass

func add_potion_effect(duration: float, t) -> void:
	var new_bar = POTION_BAR_SCENE.instantiate()
	
	new_bar.setup(duration)
	new_bar.set_potion_type(t)
	
	container.add_child.call_deferred(new_bar)
