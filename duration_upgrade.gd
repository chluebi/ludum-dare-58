extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var duration_upgrades_text = {
	0: "Short Potion Duration",
	1: "Longer Potion Duration",
	2: "Long Potion Duration",
	3: "Longest Potion Duration",
	4: "These Potions are crazy"
}

var duration_upgrades_cost = {
	0: 10,
	1: 20,
	2: 50,
	3: 100,
	4: 1000000
}

func setup():
	$"../Duration".text = duration_upgrades_text[Persistent.duration_extension]
	$"../Cost".text = "Upgrade for\n" + str(duration_upgrades_cost[Persistent.duration_extension]) + " Gold"

func _on_pressed() -> void:
	if Persistent.gold >= duration_upgrades_cost[Persistent.duration_extension]:
		Persistent.gold -= duration_upgrades_cost[Persistent.duration_extension]
		if Persistent.duration_extension < 4:
			Persistent.duration_extension += 1
		setup()
		
