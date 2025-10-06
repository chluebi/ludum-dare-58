extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var bag_upgrades_text = {
	5: "Small Wizard Pouch",
	6: "Big Wizard Pouch",
	7: "Mage Backpack",
	8: "Bag of Things",
	9: "Pocket Dimension"
}

var bag_upgrades_cost = {
	5: 10,
	6: 20,
	7: 50,
	8: 100,
	9: 1000000
}

func setup():
	$"../Bag".text = bag_upgrades_text[Persistent.slots]
	$"../Cost".text = "Upgrade for\n" + str(bag_upgrades_cost[Persistent.slots]) + " Gold"

func _on_pressed() -> void:
	if Persistent.gold >= bag_upgrades_cost[Persistent.slots]:
		Persistent.gold -= bag_upgrades_cost[Persistent.slots]
		if Persistent.slots < 9:
			Persistent.slots += 1
		setup()
		
