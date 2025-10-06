extends Control

var duration_upgrades_text = {
	0: "Short Potion Duration",
	1: "Medium Potion Duration",
	2: "Long Potion Duration",
	3: "Longest Potion Duration",
	4: "These Potions are crazy",
	5: "Potions that last...",
	6: "Worldchanging Potions",
	7: ":-}",
}

var duration_upgrades_value = {
	0: 0,
	1: 1,
	2: 2,
	3: 3,
	4: 4,
	5: 5,
	6: 6,
	7: 7
}

func setup():
	Persistent.duration_extension = duration_upgrades_value[len(Persistent.escaped)]
	$Duration.text = duration_upgrades_text[Persistent.duration_extension]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
