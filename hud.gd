extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func add_potion_ui_effect(duration: float, t):
	var durations := $DurationUI
	durations.add_potion_effect(duration, t)
