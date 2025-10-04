extends Area2D

@export var type: Constants.potion_type
@onready var sprite = $sprite

func _ready() -> void:
	set_potion_type(type)
	body_entered.connect(on_pickup)
	print("potion ready")

func set_potion_type(t: Constants.potion_type):
	type = t
	if is_node_ready():
		sprite.set_potion_type(t)


func on_pickup(body):
	print(body)
	if body.has_method("on_potion_pickup"):
		body.on_potion_pickup(self)
