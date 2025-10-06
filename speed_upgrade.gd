extends Button


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
	4: "Sonic"
}

var duration_upgrades_cost = {
	0: 0,
	1: 0,
	2: 50,
	3: 100,
	4: 1000000
}

func setup():
	$"../Speed".text = speed_upgrades_text[Persistent.duration_extension]
	#$"../Cost".text = "Upgrade for\n" + str(duration_upgrades_cost[Persistent.duration_extension]) + " Gold"

func _on_pressed() -> void:
	print("pressed")
	if Persistent.gold >= duration_upgrades_cost[Persistent.duration_extension]:
		Persistent.gold -= duration_upgrades_cost[Persistent.duration_extension]
		if Persistent.speed_upgrade < 4:
			Persistent.speed_upgrade += 1
		setup()
