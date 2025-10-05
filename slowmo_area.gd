extends Node2D

@export_range(50.0, 2000.0, 10.0, "or_greater") var radius: float = 500
@export_range(0.0, 1.0, 0.05) var slow_mo: float = 0.1
@export_range(0.0, 5.0, 0.1) var duration: float = 3.0

var affected = []
func _ready() -> void:
	for obj in $"../Environment".get_children():
		const RANGE = 500
		if "slow_mo" in obj and (obj.position - position).length_squared() < radius * radius:
			obj.modulate.r = 0.3
			obj.modulate.g = 0.3
			obj.slow_mo = slow_mo
			affected.push_back(obj)
	
	var t = Timer.new()
	add_child(t)
	t.timeout.connect(unaffect)
	t.start(duration)

func _process(delta: float) -> void:
	modulate.a = maxf(modulate.a - delta * 0.7, 0)

func unaffect():
	for obj in affected:
		# this fails if obj is freed while in slowmo
		if obj:
			obj.slow_mo = 1.0
			obj.modulate.r = 1.0
			obj.modulate.g = 1.0
	queue_free()
