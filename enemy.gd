extends CharacterBody2D

const PathFindAStar = preload("./tile_map_layer.gd")
const HEALTH_SCRIPT = preload("./health.gd")

var health = HEALTH_SCRIPT.new(100)


const MASS: float = 10.0
const ARRIVE_DISTANCE: float = 10.0

@export_range(10, 500, 0.1, "or_greater") var speed: float = 200.0

var _velocity := Vector2()

@onready var _tile_map: PathFindAStar = $"../../TileMapLayer"
@onready var player = $"../player"

var attack_target = null
var attack_timer = 0
const ATTACK_INTERVAL = 0.7

func _ready() -> void:
	$damage_hitbox.body_entered.connect(attack_player)
	$damage_hitbox.body_exited.connect(stop_attacking)
	health.death_signal.connect(on_death)
	health.health_percentage.connect($healthbar.set_health_percentage)
	$healthbar.set_color_enemy()
	$healthbar.set_health_percentage(1.0)

func _process(delta: float) -> void:
	health.animate_damage(self, delta)
	if attack_target != null and "health" in attack_target:
		attack_timer += delta
		if attack_timer >= ATTACK_INTERVAL:
			attack_target.health.take_damage(15)
			attack_timer -= ATTACK_INTERVAL


const offset := Vector2i(160, 160) * 0.5 # enemy is 16x16 scaled by 10

func _physics_process(_delta: float) -> void:
	var tile_pos := _tile_map.local_to_map(_tile_map.to_local(position))
	var path = _tile_map.find_path(_tile_map.to_global(_tile_map.map_to_local(tile_pos)) - offset, player.position)
	if len(path) < 1:
		_move_to(player.position)
		return
	
	var tile_target := _tile_map.local_to_map(path[0])
	
	if (tile_pos == tile_target):
		if len(path) > 1:
			tile_target = _tile_map.local_to_map(path[1])
		else:
			_move_to(player.position)
			return
	
	if (tile_pos.x != tile_target.x):
		_move_to(_tile_map.to_global(_tile_map.map_to_local(Vector2(tile_target.x, tile_pos.y))))
	elif (tile_pos.y != tile_target.y):
		_move_to(_tile_map.to_global(_tile_map.map_to_local(Vector2(tile_pos.x, tile_target.y))))
	else: 
		_move_to(player.position)

func attack_player(body):
	if "health" in body:
		body.health.take_damage(15)
		attack_target = body
		attack_timer = 0

func stop_attacking(body):
	if body == attack_target:
		attack_target = null


func _move_to(global_position: Vector2):
	# position = Vector2(0, 0) + offset
	velocity = (global_position - position).normalized() * speed
	move_and_slide()
	
func on_death():
	#TODO: Add a nice death animation
	queue_free()
