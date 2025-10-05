extends StaticBody2D

const POTION_DISTANCE = 150
const POTION_INTERVAL = 2.0
const POTION_SCENE = preload("res://potion_pickup.tscn")
var timer = 0


@onready var player = $"../player"

func spawn_potion():
	var r = randf_range(-PI, PI)
	var pot = POTION_SCENE.instantiate()
	pot.set_potion_type(Constants.random_potion())
	pot.position = Vector2.from_angle(r) * POTION_DISTANCE + position
	#pot.body_entered.connect(player.on_pickup)
	get_parent().add_child(pot)

func _process(delta: float) -> void:
	timer += delta
	if timer >= POTION_INTERVAL:
		spawn_potion()
		timer -= POTION_INTERVAL
