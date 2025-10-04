extends Node


const num_slots = 6

var current_slot_index: int = 0
var is_empty: Array[bool] = []
var entries: Array[int] = []

func _ready() -> void:
	for i in range(num_slots):
		is_empty.append(true)
		entries.append(0)

	_update()

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
			
			
func _select_slot_by_index(slot: int):
	current_slot_index = slot
	_update()
	
func _update():
	var hud = $"../HUD"
	hud.render_slots(is_empty, entries, current_slot_index)
