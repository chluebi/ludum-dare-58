extends Node

const SLOWMO = preload("res://slowmo_area.tscn")
const SLIME = preload("res://slime_friend.tscn")

class EffectState:
	var duration: float
	var start_time: float = -INF
	var strength: int = 0 # for stacking
	func _init(d):
		duration = d + Persistent.duration_extension
	
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
	Constants.item_type.orange: EffectState.new(10),
	Constants.item_type.yellow: EffectState.new(5),
	#Constants.potion_type.green: EffectState.new(-1),
	#Constants.item_type.blue: EffectState.new(6),
	Constants.item_type.purple: EffectState.new(15),
	Constants.item_type.pink: EffectState.new(3),
}

var time = 0
func _process(delta: float) -> void:
	time += delta

func is_active(color) -> bool:
	return effect_dictionary[color].is_active(time)

func activity_strength(color) -> int:
	return effect_dictionary[color].activity_strength(time)

func activate(drinker, color: Constants.item_type):
	if color >= Constants.item_type.empty:
		return
	Persistent.add_drunk(color)
	if drinker.has_method("drink"):
		drinker.drink()
	if color in effect_dictionary:
		var duration = effect_dictionary[color].start(time)
		var hud := $"../HUD"
		hud.add_potion_ui_effect(duration, color)
	
	#immediate effects
	if color == Constants.item_type.green:
		drinker.health.heal_damage(25)
	if color == Constants.item_type.blue:
		var s = SLOWMO.instantiate()
		s.position = drinker.position
		get_parent().add_child(s)
	if color == Constants.item_type.green:
		var slime = SLIME.instantiate()
		slime.position = drinker.position
		$"../Environment".add_child(slime)
	if color == Constants.item_type.rainbow:
		if drinker.has_method("turn_into_plant"):
			drinker.turn_into_plant()
