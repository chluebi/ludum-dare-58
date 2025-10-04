extends CharacterBody2D

const PathFindAStar = preload("./tile_map_layer.gd")


const MASS: float = 10.0
const ARRIVE_DISTANCE: float = 10.0

@export_range(10, 500, 0.1, "or_greater") var speed: float = 200.0

var _velocity := Vector2()

@onready var _tile_map: PathFindAStar = $"../TileMapLayer"
@onready var player = $"../player"

func _ready() -> void:
	pass


func _physics_process(_delta: float) -> void:
	var path = _tile_map.find_path(position, player.position) 
	
	if len(path) > 1:
		var next_local_point = path[1]
		
		# Convert the TileMap's Local Point (next_local_point) to the final World Coordinate.
		# This correctly applies the TileMap's global position AND the 10x scale.
		var next_world_point = _tile_map.to_global(next_local_point)
		
		_move_to(next_world_point)



func _move_to(global_position: Vector2):
	velocity = (global_position - position).normalized() * speed
	move_and_slide()
	
	
