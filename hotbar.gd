extends CanvasLayer

const SLOT_SCENE_PATH = "res://slot.tscn"

@export var num_slots: int = 6

var current_slot_index: int = 0
var slots: Array = []

var slot_scene: PackedScene = preload(SLOT_SCENE_PATH)
@onready var slot_container = $MarginContainer/SlotContainer


func _ready():
	_initialize_slots()
	
	if not slots.is_empty():
		_select_slot_by_index(0)


func _initialize_slots():
	if not slot_scene:
		print("ERROR: Could not load slot scene at path: %s. Please check the path and file name." % SLOT_SCENE_PATH)
		return

	for child in slot_container.get_children():
		child.queue_free()
		
	slots.clear()

	for i in range(num_slots):
		var new_slot = slot_scene.instantiate()
		
		# safety check
		if new_slot.has_method("select_slot"):
			new_slot.slot_index = i 
			
			slot_container.add_child(new_slot)
			
			slots.append(new_slot)
		else:
			print("ERROR: Instantiated slot (index %d) does not have the necessary 'select_slot' method. Check the script." % i)
			new_slot.queue_free() # clean up


func _input(event):
	for i in range(num_slots):
		if event.is_action_pressed("ui_select_" + str(i + 1)):
			_select_slot_by_index(i)
			get_viewport().set_input_as_handled()
			break
			
		if event.is_action_pressed("ui_scroll_up"):
			_select_slot_by_index((current_slot_index + 1) % num_slots)
			get_viewport().set_input_as_handled()
			break
			
		if event.is_action_pressed("ui_scroll_down"):
			var new_slot_index := current_slot_index - 1
			while new_slot_index < 0:
				new_slot_index += 6
			_select_slot_by_index(new_slot_index)
			get_viewport().set_input_as_handled()
			break

# Central function to handle selection
func _select_slot_by_index(new_index: int):
	if new_index < 0 or new_index >= slots.size():
		return

	slots[current_slot_index].deselect_slot()

	current_slot_index = new_index

	slots[current_slot_index].select_slot()
	
	print("Selected slot: %d" % (current_slot_index + 1))
