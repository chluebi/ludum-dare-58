extends StaticBody2D

const HEALTH_SCRIPT = preload("./health.gd")
const ITEM_SCENE = preload("res://potion_pickup.tscn")


@export_range(1.0, 150.0, 1.0, "or_greater") var max_health: float = 100.0
@onready var health = HEALTH_SCRIPT.new(max_health)
@onready var player = $"../player"
@onready var poison_trail = $poison_trail
const SPAWN_INTERVAL = 4.0
var spawn_timer = 0.0
var tick_timer = 0.0
const TICK_INTERVAL = 0.25
var slow_mo = 1.0
const RANGE = 800

func _ready() -> void:
	health.death_signal.connect(on_death)
	health.health_percentage.connect($healthbar.set_health_percentage)
	$healthbar.set_color_enemy()
	$healthbar.set_health_percentage(1.0)
	poison_trail.evil = true
	poison_trail.damage = 5
	# if the mushroom is the parent, the particle emitterss are affected by scaling (e.g. on damage taken) and move
	remove_child(poison_trail)
	get_parent().get_parent().add_child.call_deferred(poison_trail)


func _process(real_delta: float) -> void:
	if get_node_or_null("../tutorial_manager") != null and !$"../../tutorial_manager".enemy_activity:
		return
		
	var delta = slow_mo * real_delta
	health.animate_damage(self, real_delta)
	spawn_timer += delta
	tick_timer += delta
	if tick_timer >= TICK_INTERVAL:
		tick_timer -= TICK_INTERVAL
		poison_trail.poison_tick()
	if spawn_timer >= SPAWN_INTERVAL and (player.position - position).length_squared() < RANGE * RANGE:
		spawn_timer = 0
		poison_trail.update_carrier(player.position)

func on_death():
	poison_trail.force_cleanup()
	for x in range(2):
		var i = ITEM_SCENE.instantiate()
		var t = Constants.item_type.mushroom
		i.set_potion_type(t)
		i.position = position + Vector2(x * 50.0 - 25.0, 0)
		i.linear_velocity = Vector2.from_angle(randf_range(-PI, PI)) * 30.0
		get_parent().get_parent().add_child.call_deferred(i)
	queue_free()
