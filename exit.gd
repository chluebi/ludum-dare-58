extends Area2D

const MAIN_MENU_SCENE = preload("res://main_menu.tscn")

func _ready():
	body_entered.connect(leave_map)

func leave_map(body):
	var menu = MAIN_MENU_SCENE.instantiate()
	var cur_scene = get_tree().root.get_child(0)
	get_tree().root.add_child(menu)
	cur_scene.queue_free()
