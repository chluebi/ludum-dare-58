extends Node2D

var timer = 0
func scale_function(timer):
	return 1 - timer * timer

func _process(delta: float) -> void:
	timer += delta
	scale = Vector2(1,1) * scale_function(timer)
	rotate(1.8 * delta)
	if timer > 1.0:
		self.visible = false
		Persistent.last_run_escaped = false
		get_tree().change_scene_to_file("res://menu.tscn")
