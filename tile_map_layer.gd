extends TileMapLayer


const BASE_TILE_SIZE = Vector2i(160, 160) 

# The object for pathfinding on 2D grids.
var _astar := AStarGrid2D.new()

var _start_point := Vector2i()
var _end_point := Vector2i()
var _path := PackedVector2Array()

# Dictionary to track the last known map position of dynamic obstacles.
var _obstacle_positions: Dictionary = {}

# --- AStarGrid2D Setup ---

func _ready() -> void:
	# Region should match the size of the playable area plus one (in tiles).
	# In this demo, the playable area is 17x9 tiles, so the rect size is 18x10.
	_astar.region = Rect2i(0, 0, 100, 100)
	_astar.cell_size = BASE_TILE_SIZE 
	_astar.offset = BASE_TILE_SIZE * 0.5 
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	_astar.update()

	for pos in get_used_cells():
		if get_cell_tile_data(pos).get_custom_data("solid"):
			if _astar.is_in_boundsv(pos):
				_astar.set_point_solid(pos)

	# Initial check for dynamic obstacles
	_update_dynamic_obstacles()

# --- Dynamic Obstacle Management ---

func _process(delta: float) -> void:
	# Check for moving obstacles and update the AStarGrid2D.
	_update_dynamic_obstacles()
	
	# Optional: Recompute the path if an obstacle moved onto the current path.
	# This logic is more complex and depends on your game's needs (e.g.,
	# if the player character is waiting for a path to open).
	# For now, we'll assume pathfinding is triggered only by the 'find_path' call.


func _update_dynamic_obstacles() -> void:
	var current_obstacle_positions: Dictionary = {}

	# 1. Get all nodes in the 'static_obstacles' group
	for node in get_tree().get_nodes_in_group("static_obstacles") + get_tree().get_nodes_in_group("dynamic_obstacles"):
		# Ensure the node has a global_position property (e.g., CharacterBody2D, Node2D)
		if not node.has_method("get_global_position"):
			# Skip if the node type doesn't support global position
			continue

		var global_pos: Vector2 = node.global_position + Vector2(1, 1) # work against things that have it perfectly in top right corner
		var map_pos: Vector2i = local_to_map(to_local(global_pos))

		# Store the current position for later comparison and tracking
		current_obstacle_positions[node] = map_pos

		# Check if the node's position has changed
		if _obstacle_positions.get(node) != map_pos:
			
			# A. Unmark the old position (if it was tracked)
			var old_pos = _obstacle_positions.get(node)
			if old_pos != null and _astar.is_in_boundsv(old_pos):
				# Only unmark if no other *static* or *dynamic* obstacle occupies it.
				_astar.set_point_solid(old_pos, false) 

			# B. Mark the new position as solid (if it's a valid grid cell)
			if _astar.is_in_boundsv(map_pos):
				_astar.set_point_solid(map_pos, true)
				
	# 2. Cleanup: Unmark cells for obstacles that have been removed from the scene
	for node in _obstacle_positions:
		if node not in current_obstacle_positions:
			var old_pos: Vector2i = _obstacle_positions[node]
			if _astar.is_in_boundsv(old_pos):
				_astar.set_point_solid(old_pos, false)

	# 3. Update the tracked positions
	_obstacle_positions = current_obstacle_positions



func round_local_position(local_position: Vector2i) -> Vector2i:
	return map_to_local(local_to_map(local_position))

func is_point_walkable(local_position: Vector2) -> bool:
	var map_position: Vector2i = local_to_map(local_position)
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false

func get_local_path(path: PackedVector2Array) -> PackedVector2Array:
	var local_path = PackedVector2Array()
	for p in _path:
		local_path.append(to_local(p))
	return local_path

func find_path(global_start_point: Vector2i, global_end_point: Vector2i) -> PackedVector2Array:
	_update_dynamic_obstacles() 

	var local_start_point = to_local(global_start_point)
	var local_end_point = to_local(global_end_point)

	_start_point = local_to_map(local_start_point)
	_end_point = local_to_map(local_end_point)
		
	if !_astar.is_in_bounds(_start_point.x, _start_point.y):
		return PackedVector2Array()
	if !_astar.is_in_bounds(_end_point.x, _end_point.y):
		return PackedVector2Array()

	# Check if start/end points are blocked by a dynamic obstacle.
	if _astar.is_point_solid(_start_point) or _astar.is_point_solid(_end_point):
		return PackedVector2Array() # Return empty path
  
	_path = _astar.get_point_path(_start_point, _end_point)
	
	return get_local_path(_path)
