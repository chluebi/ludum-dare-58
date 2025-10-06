extends StaticBody2D

const POTION_DISTANCE = 150
const POTION_SCENE = preload("res://potion_pickup.tscn")



@onready var player = $"../player"
@onready var recipe = $Recipe


var ingredient1_in = false
var ingredient2_in = false
var ingredient3_in = false
var ingredient4_in = false
var ingredient5_in = false
var ingredient6_in = false

var result_type = Constants.item_type.rainbow
var brew_time = 40.0

var brewing = false
var timer = 0

func _ready() -> void:
	$CollectionRange.body_entered.connect(collect_item)
	
func collect_item(body):
	print('collect item', body)
	if brewing:
		return
		
	if "type" in body:
		if !ingredient1_in and body.type == Constants.item_type.orange:
			ingredient1_in = true
			$insert.play()
			body.queue_free()
			update_recipe_ui()
			return
			
		if !ingredient2_in and body.type == Constants.item_type.yellow:
			ingredient2_in = true
			$insert.play()
			body.queue_free()
			update_recipe_ui()
			return
			
		if !ingredient3_in and body.type == Constants.item_type.pink:
			ingredient3_in = true
			$insert.play()
			body.queue_free()
			update_recipe_ui()
			return
			
		if !ingredient4_in and body.type == Constants.item_type.blue:
			ingredient4_in = true
			$insert.play()
			body.queue_free()
			update_recipe_ui()
			return
			
		if !ingredient5_in and body.type == Constants.item_type.purple:
			ingredient5_in = true
			$insert.play()
			body.queue_free()
			update_recipe_ui()
			return
			
		if !ingredient6_in and body.type == Constants.item_type.green:
			ingredient6_in = true
			$insert.play()
			body.queue_free()
			update_recipe_ui()
			return			
	
func setup():
	update_recipe_ui()

	
func update_recipe_ui():
	if ingredient1_in and ingredient2_in and ingredient3_in and ingredient4_in and ingredient5_in and ingredient6_in:
		brewing = true
		timer = 0
	else:
		brewing = false
		
	$Recipe.setup(
		ingredient1_in,
		ingredient2_in,
		ingredient3_in,
		ingredient4_in,
		ingredient5_in,
		ingredient6_in
	)

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
			
			ingredient1_in = false
			ingredient2_in = false
			ingredient3_in = false
			ingredient4_in = false
			ingredient5_in = false
			ingredient6_in = false
			
			$Recipe.setup(
				ingredient1_in,
				ingredient2_in,
				ingredient3_in,
				ingredient4_in,
				ingredient5_in,
				ingredient6_in
			)
		
