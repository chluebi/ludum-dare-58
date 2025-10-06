extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Environment/cauldron_orange".setup(
		Constants.item_type.firestone,
		false,
		Constants.item_type.empty,
		Constants.item_type.orange,
		4.0
	)
	
	$"../Environment/cauldron_yellow".setup(
		Constants.item_type.bone,
		true,
		Constants.item_type.bone,
		Constants.item_type.yellow,
		8.0
	)
	
	$"../Environment/cauldron_pink".setup(
		Constants.item_type.flower,
		false,
		Constants.item_type.empty,
		Constants.item_type.pink,
		6.0
	)
	
	$"../Environment/cauldron_blue".setup(
		Constants.item_type.powder,
		false,
		Constants.item_type.empty,
		Constants.item_type.blue,
		10.0
	)
	
	$"../Environment/cauldron_purple".setup(
		Constants.item_type.pink,
		true,
		Constants.item_type.mushroom,
		Constants.item_type.purple,
		10.0
	)
	
	$"../Environment/cauldron_green".setup(
		Constants.item_type.blue,
		true,
		Constants.item_type.slime,
		Constants.item_type.green,
		12.0
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
