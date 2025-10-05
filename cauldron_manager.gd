extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Environment/cauldron".setup(
		Constants.item_type.firestone,
		false,
		Constants.item_type.empty,
		Constants.item_type.orange,
		4.0
	)
	
	$"../Environment/cauldron2".setup(
		Constants.item_type.bone,
		true,
		Constants.item_type.bone,
		Constants.item_type.yellow,
		8.0
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
