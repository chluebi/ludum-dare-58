extends Area2D

const MAIN_MENU_SCENE = preload("res://menu.tscn")
@onready var inventory = $"../inventory_manager"

func _ready():
	body_entered.connect(leave_map)

func leave_map(body):
	if !body.is_in_group("player"):
		return
	print("before leaving: ", Persistent.tutorial_completed)
	for i in range(inventory.num_slots):
		if !inventory.is_empty[i]:
			print("item in slot ", i)
			Persistent.add_escaped(inventory.entries[i])
			
	Persistent.last_run_escaped = true
	get_tree().change_scene_to_packed.call_deferred(MAIN_MENU_SCENE)
	#var menu = MAIN_MENU_SCENE.instantiate()
	#var cur_scene = get_tree().root.get_child(0)
	#get_tree().root.add_child(menu)
	#cur_scene.queue_free()
