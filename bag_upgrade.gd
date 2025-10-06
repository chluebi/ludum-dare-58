extends Control


var bag_upgrades_text = {
	5: "Small Wizard Pouch",
	6: "Big Wizard Pouch",
	7: "Mage Backpack",
	8: "Bag of Things",
	9: "Pocket Dimension"
}

var bag_upgrades_value = {
	0: 5,
	1: 5,
	2: 6,
	3: 7,
	4: 7,
	5: 8,
	6: 9,
	7: 9
}

func setup():
	Persistent.slots = bag_upgrades_value[len(Persistent.escaped)]
	$Bag.text = bag_upgrades_text[Persistent.slots]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
