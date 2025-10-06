extends Node


var enemy_activity = false

@onready var INVENTORY_MANAGER = $"../inventory_manager"

@onready var tutorial_movement = $Control/Node2D/TutorialMovementHUD
@onready var tutorial_find = $Control/Node2D/TutorialFindHUD
@onready var tutorial_drop = $Control/Node2D/TutorialDropHUD
@onready var tutorial_return = $Control/Node2D/TutorialReturnHUD
@onready var tutorial_wait = $Control/Node2D/TutorialWaitHUD
@onready var tutorial_drink = $Control/Node2D/TutorialDrinkHUD
@onready var tutorial_mouse = $Control/Node2D/TutorialMouseHUD

@onready var current_step = tutorial_movement

var all_tutorials = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	all_tutorials.append(tutorial_movement)
	all_tutorials.append(tutorial_find)
	all_tutorials.append(tutorial_drop)
	all_tutorials.append(tutorial_return)
	all_tutorials.append(tutorial_wait)
	all_tutorials.append(tutorial_drink)
	all_tutorials.append(tutorial_mouse)
	if Persistent.tutorial_completed:
		stop_tutorial()
	show_current()
	INVENTORY_MANAGER.pickup_item(Constants.item_type.orange)
	INVENTORY_MANAGER.pickup_item(Constants.item_type.yellow)
	INVENTORY_MANAGER.pickup_item(Constants.item_type.pink)
	INVENTORY_MANAGER.pickup_item(Constants.item_type.blue)
	INVENTORY_MANAGER.pickup_item(Constants.item_type.purple)
	INVENTORY_MANAGER.pickup_item(Constants.item_type.green)
	

func show_current():
	for tutorial in all_tutorials:
		if tutorial == current_step:
			tutorial.show()
		else:
			tutorial.hide()

var WASD_INPUTS = 0
var MOUSE_INPUTS = 0

func stop_tutorial():
	Persistent.tutorial_completed = true
	enemy_activity = true
	current_step = null
	for node in get_tree().get_nodes_in_group("tutorial_blockers"):
		node.queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("move_right"):
		WASD_INPUTS += 1
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("move_left"):
		WASD_INPUTS += 1
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("move_down"):
		WASD_INPUTS += 1
	if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("move_up"):
		WASD_INPUTS += 1
		
	if Input.is_action_pressed("shoot"):
		MOUSE_INPUTS += 1
		
	if current_step == tutorial_movement and WASD_INPUTS > 3:
		current_step = tutorial_find
		show_current()
		
	if current_step == tutorial_find \
		and INVENTORY_MANAGER.inventory_contains(Constants.item_type.empty) \
		and INVENTORY_MANAGER.inventory_contains(Constants.item_type.firestone):
		current_step = tutorial_return
		show_current()
		
	if current_step == tutorial_return \
		and ($"../Environment/player".position - $"../Environment/cauldron_orange".position).length() < 160:
		current_step = tutorial_drop
		show_current()
		
	if current_step == tutorial_drop \
		and $"../Environment/cauldron_orange".brewing:
		current_step = tutorial_wait
		show_current()
		
	if INVENTORY_MANAGER.inventory_contains(Constants.item_type.orange) and current_step != null \
		and all_tutorials.find(current_step) < all_tutorials.find(tutorial_drink):
		current_step = tutorial_drink
		show_current()
	
	if current_step == tutorial_drink \
		and !INVENTORY_MANAGER.inventory_contains(Constants.item_type.orange):
		current_step = tutorial_mouse
		MOUSE_INPUTS = 0
		show_current()
		
	if current_step == tutorial_mouse \
		and MOUSE_INPUTS > 2:
		current_step = null
		stop_tutorial()
		show_current()
