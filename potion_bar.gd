extends HBoxContainer

@export var total_duration: float = 5.0
var current_duration: float

@onready var progress_bar: ProgressBar = $ColorRect/PotionBarElements/ProgressBar
@onready var potion: Sprite2D = $ColorRect/PotionBarElements/Icon/potion

func setup(duration: float):
	total_duration = duration
	current_duration = duration
	var bar: ProgressBar = $ColorRect/PotionBarElements/ProgressBar
	
	bar.max_value = duration
	bar.value = duration

func set_potion_type(t):
	var potion: Sprite2D = $ColorRect/PotionBarElements/Icon/potion
	potion.set_potion_type(t)

func _process(delta):
	current_duration -= delta
	progress_bar.value = current_duration
	
	# Remove the bar when the time runs out
	if current_duration <= 0.0:
		queue_free()
