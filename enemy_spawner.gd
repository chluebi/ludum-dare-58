extends Node2D

const SPAWN_INTERVAL = 5.0
const ALLOWED_REGION = Rect2(0,0,2400, 1500)
const ENEMY_SCENE = preload("res://enemy.tscn")
@onready var player = $"../player"
var camera_region = Rect2(0,0,1152,648)
var spawn_timer = 0

func spawn_enemy(pos):
	var enemy = ENEMY_SCENE.instantiate()
	enemy.position = pos
	get_parent().add_child.call_deferred(enemy)

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= SPAWN_INTERVAL:
		camera_region.position = player.position - camera_region.size / 2
		var x = randf_range(ALLOWED_REGION.position.x, ALLOWED_REGION.end.x)
		var y = randf_range(ALLOWED_REGION.position.y, ALLOWED_REGION.end.y)
		if camera_region.has_point(Vector2(x,y)):
			print("illegal spawn")
		else:
			spawn_timer -= SPAWN_INTERVAL
			spawn_enemy(Vector2(x,y))
