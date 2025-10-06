extends Node2D

const WAVE_INTERVAL = 30.0
const SPAWN_INTERVAL = 4.0

const ALLOWED_REGION = Rect2(0,0,2400, 1500)

const SKULL_SCENE = preload("res://skull.tscn")
const PILE_SCENE = preload("res://skullpile.tscn")
const GHOST_SCENE = preload("res://ghost.tscn")
const MUSHROOM_SCENE = preload("res://mushroom.tscn")

const FIRST_WAVE = {
	SKULL_SCENE: 0,
	PILE_SCENE: 2,
	GHOST_SCENE: 4,
	MUSHROOM_SCENE: 6
}

const COSTS = {
	SKULL_SCENE: 1,
	PILE_SCENE: 5,
	GHOST_SCENE: 3,
	MUSHROOM_SCENE: 6
}

const LOCATIONS = {
	SKULL_SCENE: "spawn_location",
	PILE_SCENE: "pile_location",
	GHOST_SCENE: "spawn_location",
	MUSHROOM_SCENE: "mushroom_location"
}



@onready var player = $"../Environment/player"
@onready var environment = $"../Environment"
var camera_region = Rect2(0,0,1600,900)
var spawn_timer = SPAWN_INTERVAL
var wave_timer = WAVE_INTERVAL

var WAVE = 0
var current_wave_max_value = 5
var current_wave_value = 0


func spawn_enemy(pos, scene):
	var enemy = scene.instantiate()
	enemy.position = pos
	environment.add_child.call_deferred(enemy)

func try_spawn_enemy(enemy_scene) -> bool:
	for node in get_tree().get_nodes_in_group(LOCATIONS[enemy_scene]):
		if camera_region.has_point(node.position):
			continue
		else:
			spawn_enemy(node.position, enemy_scene)
			return true
	
	return false


func spawn_leftovers():
	while current_wave_value < current_wave_max_value:
		var enemy_scene = COSTS.keys().pick_random()
		if FIRST_WAVE[enemy_scene] > WAVE:
			continue
		if current_wave_value + COSTS[enemy_scene] > current_wave_max_value * 2:
			continue
		
		if try_spawn_enemy(enemy_scene):
			print('leftover spawned ', COSTS[enemy_scene])
			current_wave_value += COSTS[enemy_scene]
			break


func spawn_wave():
	WAVE += 1
	current_wave_value = 0
	current_wave_max_value *= 1.1
	while current_wave_value < current_wave_max_value/2:
		var enemy_scene = COSTS.keys().pick_random()
		if FIRST_WAVE[enemy_scene] > WAVE:
			continue
		if current_wave_value + COSTS[enemy_scene] > current_wave_max_value * 2:
			continue
		
		if try_spawn_enemy(enemy_scene):
			print('wave spawned ', COSTS[enemy_scene])
			current_wave_value += COSTS[enemy_scene]	


func _process(delta: float) -> void:
	if get_node_or_null("../tutorial_manager") != null and !$"../tutorial_manager".enemy_activity:
		return
	

	wave_timer += delta
	spawn_timer += delta
	if wave_timer >= WAVE_INTERVAL:
		spawn_wave()
		wave_timer = 0
	elif spawn_timer >= SPAWN_INTERVAL:
		spawn_leftovers()
		spawn_timer = 0
