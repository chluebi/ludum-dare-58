extends StaticBody2D

const POTION_DISTANCE = 150
const POTION_SCENE = preload("res://potion_pickup.tscn")


@export var item_type: Constants.item_type

@onready var player = $"../player"
@onready var inventory_manager = $"../../inventory_manager"
@onready var source = $Source

var result_type = Constants.item_type.empty


func _ready() -> void:
	$CollectionRange.body_entered.connect(collect_item)
	setup(item_type)
	
func collect_item(body):
	if "type" in body:
		if body.type == result_type:
			body.queue_free()
			return
	
	if "health" in body:
		inventory_manager.pickup_item(result_type)
	
func setup(set_result_type: Constants.item_type):
	result_type = set_result_type
	update_recipe_ui()

	
func update_recipe_ui():
	source.setup(result_type)

func _process(delta: float) -> void:
	source.move_to(position.x, position.y)
