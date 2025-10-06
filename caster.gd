extends CharacterBody2D

const PathFindAStar = preload("./tile_map_layer.gd")
const HEALTH_SCRIPT = preload("./health.gd")
const ITEM_SCENE = preload("res://potion_pickup.tscn")
const FIREBALL_SCENE = preload("res://fireball.tscn")


@export_range(1.0, 150.0, 1.0, "or_greater") var max_health: float = 100.0
@onready var health = HEALTH_SCRIPT.new(max_health)


const MASS: float = 10.0
const ARRIVE_DISTANCE: float = 10.0

@export_range(10, 500, 0.1, "or_greater") var speed: float = 200.0
@export_range(0, 100, 0.1, "or_greater") var damage: float = 15.0
@export_range(100.0, 800, 10.0, "or_greater") var shoot_range: float = 700

@export var can_go_through_walls: bool = false

var _velocity := Vector2()

@onready var _tile_map: PathFindAStar = $"../../TileMapLayer"
@onready var player = $"../player"

@export var can_drop: Array[Constants.item_type] = []

var attack_timer = 0.0
const ATTACK_INTERVAL = 3.0
var slow_mo = 1.0

func _ready() -> void:
	health.death_signal.connect(on_death)
	health.health_percentage.connect($healthbar.set_health_percentage)
	$healthbar.set_color_enemy()
	$healthbar.set_health_percentage(1.0)

func spawn_fireball(aim_direction):
	var fireball = FIREBALL_SCENE.instantiate()
	fireball.position = position
	fireball.direction = aim_direction
	fireball.size = 0
	fireball.is_enemy = true
	$shoot.play()
	get_parent().add_child(fireball)

func _process(real_delta: float) -> void:
	var delta = slow_mo * real_delta
	health.animate_damage(self, real_delta)
	attack_timer += delta
	if attack_timer >= ATTACK_INTERVAL:
		spawn_fireball((player.position + randf_range(-0.2, 1.0) * player.velocity - position).normalized())
		attack_timer -= ATTACK_INTERVAL


const offset := Vector2i(160, 160) * 0.5 # enemy is 16x16 scaled by 10

func _physics_process(_delta: float) -> void:
	if $"../../tutorial_manager" and !$"../../tutorial_manager".enemy_activity:
		return
	
	if (position - player.position).length_squared() <= shoot_range * shoot_range:
		return
	var target_position = player.position + (position - player.position).normalized() * 500.0
	if can_go_through_walls:
		_move_to(target_position)
		return
	var tile_pos := _tile_map.local_to_map(_tile_map.to_local(position))
	var path = _tile_map.find_path(_tile_map.to_global(_tile_map.map_to_local(tile_pos)) - offset, target_position)
	if len(path) < 1:
		_move_to(target_position)
		return
	
	var tile_target := _tile_map.local_to_map(path[0])
	
	if (tile_pos == tile_target):
		if len(path) > 1:
			tile_target = _tile_map.local_to_map(path[1])
		else:
			_move_to(target_position)
			return
	
	if (tile_pos.x != tile_target.x):
		_move_to(_tile_map.to_global(_tile_map.map_to_local(Vector2(tile_target.x, tile_pos.y))))
	elif (tile_pos.y != tile_target.y):
		_move_to(_tile_map.to_global(_tile_map.map_to_local(Vector2(tile_pos.x, tile_target.y))))
	else: 
		_move_to(target_position)


func _move_to(global_position: Vector2):
	# position = Vector2(0, 0) + offset
	velocity = (global_position - position).normalized() * speed * slow_mo
	var sprite = $AnimatedSprite2D
	if velocity.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	move_and_slide()
	
func on_death():
	var i = ITEM_SCENE.instantiate()
	if len(can_drop) > 0:
		var t = can_drop[randi_range(0, len(can_drop) - 1)]
		i.set_potion_type(t)
		i.position = position
		i.linear_velocity = Vector2.from_angle(randf_range(-PI, PI)) * 30.0
		get_parent().get_parent().add_child.call_deferred(i)
	queue_free()
