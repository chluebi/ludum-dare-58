extends Node

class EffectState:
	var duration: float
	var start_time: float = -INF
	func _init(d):
		duration = d
	
	func start(time):
		start_time = time
	
	func is_active(time) -> bool:
		return start_time + duration > time
	
var effect_dictionary = {
	Constants.potion_type.orange: EffectState.new(10),
	Constants.potion_type.yellow: EffectState.new(5),
	#Constants.potion_type.green: EffectState.new(-1),
	Constants.potion_type.blue: EffectState.new(6),
	Constants.potion_type.purple: EffectState.new(15),
	Constants.potion_type.pink: EffectState.new(3),
}

var time = 0
func _process(delta: float) -> void:
	time += delta

func is_active(color) -> bool:
	return effect_dictionary[color].is_active(time)

func activate(color: Constants.potion_type):
	if color in effect_dictionary:
		effect_dictionary[color].start(time)
