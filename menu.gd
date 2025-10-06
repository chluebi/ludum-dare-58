extends CanvasLayer

@onready var MAIN_SCENE = load("res://main.tscn")
var potion_scene: PackedScene = preload("res://item_sprite.tscn")
#var potions: Array[Constants.item_type] = [Constants.item_type.orange, Constants.item_type.blue, Constants.item_type.green]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Persistent.number_of_runs += 1
	
	print("after leaving: ", Persistent.tutorial_completed)
	print(Persistent.just_escaped)
	print(Persistent.just_drunk)
	
	render_potions(Persistent.escaped)
	if Constants.item_type.green in Persistent.drunk:
		show_slime()

	if Persistent.number_of_runs > 1:
		$Return.show()
		$Start.hide()
		
		render_log()
		
		Persistent.just_escaped = []
		Persistent.just_drunk = []
		
		$Return/BagUpgrade.setup()
		$Return/DurationUpgrade.setup()
		$Return/SpeedUpgrade.setup()
	else:
		$Return.hide()
		$Start.show()

var potion_visual_names = {
	Constants.item_type.orange: "Orange Potion",
	Constants.item_type.yellow: "Yellow Potion",
	Constants.item_type.pink: "Pink Potion",
	Constants.item_type.blue: "Blue Potion",
	Constants.item_type.purple: "Purple Potion",
	Constants.item_type.green: "Green Potion",
	Constants.item_type.rainbow: "Rainbow Potion"
}

var potion_usage_names = {
	Constants.item_type.orange: "Fireball Magic",
	Constants.item_type.yellow: "Haste Magic",
	Constants.item_type.pink: "Healing Magic",
	Constants.item_type.blue: "Manasurge Magic",
	Constants.item_type.purple: "Potion Cloud Magic",
	Constants.item_type.green: "Slime Friend Magic",
	Constants.item_type.rainbow: "The Greatest Magic of All"
}

var potion_values = {
	Constants.item_type.orange: 2,
	Constants.item_type.yellow: 3,
	Constants.item_type.pink: 4,
	Constants.item_type.blue: 6,
	Constants.item_type.purple: 8,
	Constants.item_type.green: 12,
	Constants.item_type.rainbow: 42
}

func render_log():
	var text: String = ""
	if Persistent.last_run_escaped:
		text += "Successfully Escaped...\n"
		for potion in Persistent.just_drunk:
			text += "Felt the effects of " + potion_usage_names[potion] + "\n"
		for potion in Persistent.just_escaped:
			text += "Collected " + potion_visual_names[potion] + "\n"
	else:
		text += "All potions were lost...\n"
		
	$Return/Log.text = text
	
	
func _on_start_pressed() -> void:
	start_game()
	

func start_game():
	get_tree().change_scene_to_packed(MAIN_SCENE)
	#var main = MAIN_SCENE.instantiate()
	#get_tree().root.add_child.call_deferred(main)
	#queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


const scale_factor = Vector2(1600/96, 1600/96)

func render_potions(potions: Array[Constants.item_type]) -> void:
	var container = $PanelContainer
	
	for i in range(len(potions)):
		var child = potion_scene.instantiate()
		child.scale = Vector2(1, 1) * scale_factor
		child.position = Vector2(20 + i * scale_factor.x * 4.2,58)
		child.set_item_type(potions[i])
		
		container.add_child(child)
		

func show_slime():
	$Slime.visible = true
	$Slime.play()
