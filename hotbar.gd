extends CanvasLayer

const SLOT_SCENE_PATH = "res://slot.tscn"

var slots: Array = []

var slot_scene: PackedScene = preload(SLOT_SCENE_PATH)
@onready var slot_container = $MarginContainer/SlotContainer


func render_slots(is_empty: Array[bool], entries: Array[Constants.item_type], current_slot_index):
	assert(len(is_empty) == len(entries) and 0 <= current_slot_index and current_slot_index < len(is_empty))

	if len(slots) == 0:
		for i in range(len(is_empty)):
			var new_slot = slot_scene.instantiate()
			new_slot.setup(i, is_empty[i], entries[i], i == current_slot_index)
			slot_container.add_child.call_deferred(new_slot)
			slots.append(new_slot)
	else:
		for i in range(len(is_empty)):
			slots[i].setup(i, is_empty[i], entries[i], i == current_slot_index)
	

	
