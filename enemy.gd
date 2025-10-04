extends CharacterBody2D

const PathFindAStar = preload("./tile_map_layer.gd")
const HEALTH_SCRIPT = preload("./health.gd")

var health = HEALTH_SCRIPT.new()


const MASS: float = 10.0
const ARRIVE_DISTANCE: float = 10.0

@export_range(10, 500, 0.1, "or_greater") var speed: float = 200.0

var _velocity := Vector2()

@onready var _tile_map: PathFindAStar = $"../TileMapLayer"
@onready var player = $"../player"

func _ready() -> void:
	$damage_hitbox.body_entered.connect(attack_player)
	health.death_signal.connect(on_death)

func _process(delta: float) -> void:
	health.animate_damage(self, delta)


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
			
	print('tile pos ', tile_pos)
	print('tile target ', tile_target)
	
	if (tile_pos.x != tile_target.x):
		print('moving x')
		_move_to(_tile_map.to_global(_tile_map.map_to_local(Vector2(tile_target.x, tile_pos.y))))
	elif (tile_pos.y != tile_target.y):
		print('moving y')
		_move_to(_tile_map.to_global(_tile_map.map_to_local(Vector2(tile_pos.x, tile_target.y))))
	else: 
		print('else')
		_move_to(player.position)

func attack_player(body):
	if "health" in body:
		body.health.take_damage(15)


func _move_to(global_position: Vector2):
	# position = Vector2(0, 0) + offset
	print("moving to", global_position)
	velocity = (global_position - position).normalized() * speed
	move_and_slide()
	
func on_death():
	print("i died")
