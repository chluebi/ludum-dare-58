extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var speed_upgrades_text = {
	0: "Move slightly faster",
	1: "Move slightly faster",
	2: "Move significantly faster",
	3: "Speed",
	4: "Sonic",
	5: "Supersonic",
	6: "Mach 100",
	7: "c",
}


func setup():
	$Speed.text = speed_upgrades_text[Persistent.duration_extension]



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
