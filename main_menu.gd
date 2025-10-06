extends Node2D

@onready var MAIN_SCENE = load("res://main.tscn")
var tutorial_done = false
var collected = []

func start_game():
	var main = MAIN_SCENE.instantiate()
	main.get_node("tutorial_manager").tutorial_enabled = !tutorial_done
	get_tree().root.add_child.call_deferred(main)
	queue_free()

func _ready():
	print("main menu ready")
	var t = Timer.new()
	t.timeout.connect(start_game)
	add_child(t)
	t.start(2.0)
