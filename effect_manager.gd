extends Node

class EffectState:
	var duration: float
	var start_time: float = -INF
	var strength: int = 0 # for stacking
	func _init(d):
		duration = d
	
	func start(time) -> float:
		if !is_active(time):
			strength = 0
		start_time = time
		strength = clamp(strength + 1, 0, 5)
		return duration
	
	func is_active(time) -> bool:
		return start_time + duration > time
	
	func activity_strength(time) -> int:
		if is_active(time):
			return strength
		else:
			return 0
	
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

func activity_strength(color) -> int:
	return effect_dictionary[color].activity_strength(time)

func activate(drinker, color: Constants.potion_type):
	if color in effect_dictionary:
		var duration = effect_dictionary[color].start(time)
		var hud := $"../HUD"
		hud.add_potion_ui_effect(duration, color)
	
	#immediate effects
	if color == Constants.potion_type.green:
		drinker.health.heal_damage(25)
