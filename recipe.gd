extends CanvasLayer

var brew_time = 10.0
var current_brew_time = 0.0
var brewing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var bar = $Control/ProgressBar
	if brewing:
		current_brew_time += delta
		
		bar.show()
		bar.value = 100.0 * clampf(current_brew_time/brew_time, 0, 1)
	else:
		bar.hide()


func move_to(x: float, y: float):
	# because transform of Canvas Layer is set to 2
	$Control.position = Vector2(x/2 - 80, (y-130)/2 - 30)

func setup(
	empty_in: bool,
	ingredient1_type: Constants.item_type, ingredient1_in: bool,
	recipe_has_ingredient2: bool,
	ingredient2_type: Constants.item_type, ingredient2_in: bool,
	result_type: Constants.item_type,
	set_brew_time: float):
	
	var empty = $Control/Empty
	empty.set_item_type(Constants.item_type.empty)
	empty.modulate = Color(empty.modulate.r, empty.modulate.g, empty.modulate.b, 1.0 if empty_in else 0.2)
	
	var ingredient1 = $Control/Ingredient1
	ingredient1.set_item_type(ingredient1_type)
	ingredient1.modulate = Color(ingredient1.modulate.r, ingredient1.modulate.g, ingredient1.modulate.b, 1.0 if ingredient1_in else 0.2)
	
	var ingredient2 = $Control/Ingredient2
	if !recipe_has_ingredient2:
		ingredient2.modulate = Color(ingredient2.modulate.r, ingredient2.modulate.g, ingredient2.modulate.b, 0)
	else:
		ingredient2.set_item_type(ingredient2_type)
		ingredient2.modulate = Color(ingredient2.modulate.r, ingredient2.modulate.g, ingredient2.modulate.b, 1.0 if ingredient2_in else 0.2)
		
	var result = $Control/Result
	result.set_item_type(result_type)
	
	if empty_in and ingredient1_in and (!recipe_has_ingredient2 or ingredient2_in):
		brewing = true
		brew_time = set_brew_time
		current_brew_time = 0
	else:
		brewing = false
