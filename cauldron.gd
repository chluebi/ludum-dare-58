extends StaticBody2D

const POTION_DISTANCE = 150
const POTION_SCENE = preload("res://potion_pickup.tscn")

@export var color: Constants.item_type = Constants.item_type.orange

@onready var player = $"../player"
@onready var recipe = $Recipe

var empty_in = false

var ingredient1_type = Constants.item_type.empty
var ingredient1_in = false

var recipe_has_ingredient2 = false
var ingredient2_type = Constants.item_type.empty
var ingredient2_in = false

var result_type = Constants.item_type.empty
var brew_time = 0

var brewing = false
var timer = 0

func _ready() -> void:
	$CollectionRange.body_entered.connect(collect_item)
	if color < Constants.item_type.empty:
		var c = color
		if c >= Constants.item_type.rainbow:
			c -= 1
		$Sprite2D.region_rect.position = 12 * Vector2(c % 2, c / 2)
	
func collect_item(body):
	print('collect item', body)
	if brewing:
		return
		
	if "type" in body:
		if !empty_in and body.type == Constants.item_type.empty:
			empty_in = true
			$insert.play()
			body.queue_free()
			update_recipe_ui()
			return
			
		if !ingredient1_in and body.type == ingredient1_type:
			ingredient1_in = true
			$insert.play()
			body.queue_free()
			update_recipe_ui()
			return
		
		if recipe_has_ingredient2 and !ingredient2_in and body.type == ingredient2_type:
			ingredient2_in = true
			body.queue_free()
			$insert.play()
			update_recipe_ui()
			return
	
func setup(
	set_ingredient1_type: Constants.item_type,
	set_recipe_has_ingredient2: bool,
	set_ingredient2_type: Constants.item_type,
	set_result_type: Constants.item_type,
	set_brew_time: float):
		
	ingredient1_type = set_ingredient1_type
	recipe_has_ingredient2 = set_recipe_has_ingredient2
	ingredient2_type = set_ingredient2_type
	result_type = set_result_type
	brew_time = set_brew_time
	
	update_recipe_ui()

	
func update_recipe_ui():
	if empty_in and ingredient1_in and (!recipe_has_ingredient2 or ingredient2_in):
		brewing = true
		timer = 0
	else:
		brewing = false
		
	$Recipe.setup(empty_in,
		ingredient1_type, ingredient1_in,
		recipe_has_ingredient2,
		ingredient2_type, ingredient2_in,
		result_type,
		brew_time)

func spawn_potion():
	var r = randf_range(-PI, PI)
	var pot = POTION_SCENE.instantiate()
	pot.set_potion_type(result_type)
	pot.position = Vector2.from_angle(r) * POTION_DISTANCE + position
	get_parent().add_child(pot)

func _process(delta: float) -> void:
	if brewing:
		timer += delta
		if timer >= brew_time:
			$finish.play()
			spawn_potion()
	
			timer = 0
			
			empty_in = false
			ingredient1_in = false
			ingredient2_in = false
			brewing = false
			
			$Recipe.setup(empty_in,
				ingredient1_type, ingredient1_in,
				recipe_has_ingredient2,
				ingredient2_type, ingredient2_in,
				result_type,
				brew_time)
		
