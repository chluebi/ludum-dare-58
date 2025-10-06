extends Node


const num_slots = 6

var current_slot_index: int = 0
var is_empty: Array[bool] = []
var entries: Array[Constants.item_type] = []

func _ready() -> void:
	for i in range(num_slots):
		is_empty.append(true)
		entries.append(0)
	pickup_item(Constants.item_type.purple)
	#pickup_item(Constants.item_type.orange)
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
		
		if event.is_action_pressed("drink"):
			drink()
			get_viewport().set_input_as_handled()
			break
			
func _select_slot_by_index(slot: int):
	current_slot_index = slot
	_update()
	
func _update():
	var hud = $"../HUD"
	hud.render_slots(is_empty, entries, current_slot_index)

@onready var player = $"../Environment/player"
func drink():
	if is_empty[current_slot_index] or !Constants.is_drinkable_potion(entries[current_slot_index]):
		return
		
	var effect_manager = $"../effect_manager"
	effect_manager.activate(player, entries[current_slot_index])
	entries[current_slot_index] = Constants.item_type.empty
	_update()
	
func drink_from_ground(potion_type: Constants.item_type):
	var effect_manager = $"../effect_manager"
	effect_manager.activate(player, potion_type)
	_update()
	
	
func remove_current_item() -> Variant:
	if is_empty[current_slot_index]:
		return null
	var value = entries[current_slot_index]
	is_empty[current_slot_index] = true
	_update()
	return value

	
func pickup_item(potion_type: Constants.item_type) -> bool:
	if potion_type == Constants.item_type.none:
		return false
	for i in range(num_slots):
		if is_empty[i]:
			is_empty[i] = false
			entries[i] = potion_type
			_update()
			return true
	
	return false
	
func inventory_contains(potion_type: Constants.item_type) -> bool:
	for i in range(num_slots):
		if !is_empty[i] and entries[i] == potion_type:
			return true
	return false
