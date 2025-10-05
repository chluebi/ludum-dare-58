extends CharacterBody2D

const HEALTH_SCRIPT = preload("./health.gd")

var health = HEALTH_SCRIPT.new(100)


const MASS: float = 10.0
const ARRIVE_DISTANCE: float = 10.0

const ENEMY_SCENE = preload("res://skull.tscn")

@export_range(0, 60.0, 0.1, "or_greater") var spawn_time: float = 10.0


var attack_target = null
var attack_timer = 0
const ATTACK_INTERVAL = 0.7

@onready var timer := $Timer

func _ready() -> void:
	$damage_hitbox.body_entered.connect(attack_player)
	$damage_hitbox.body_exited.connect(stop_attacking)
	health.death_signal.connect(on_death)
	health.health_percentage.connect($healthbar.set_health_percentage)
	$healthbar.set_color_enemy()
	$healthbar.set_health_percentage(1.0)
	
	timer.wait_time = spawn_time
	timer.start()

func _process(delta: float) -> void:
	health.animate_damage(self, delta)
	if attack_target != null and "health" in attack_target:
		attack_timer += delta
		if attack_timer >= ATTACK_INTERVAL:
			attack_target.health.take_damage(15)
			attack_timer -= ATTACK_INTERVAL
	
	var sprite = $AnimatedSprite2D
	sprite.frame = floor((1 - (timer.time_left / timer.wait_time)) * 5)
	

func spawn_enemy(pos):
	if $"../../tutorial_manager" and !$"../../tutorial_manager".enemy_activity:
		return
		
	var enemy = ENEMY_SCENE.instantiate()
	enemy.position = pos
	get_parent().add_child.call_deferred(enemy)

func _on_timer_timeout() -> void:
	var r := randf_range(160, 320)
	var phi := randf_range(0, 2 * PI)
	
	spawn_enemy(position + Vector2(r * sin(phi), r * cos(phi)))


const offset := Vector2i(160, 160) * 0.5 # enemy is 16x16 scaled by 10


func attack_player(body):
	if "health" in body:
		body.health.take_damage(15)
		attack_target = body
		attack_timer = 0

func stop_attacking(body):
	if body == attack_target:
		attack_target = null


	
func on_death():
	#TODO: Add a nice death animation
	queue_free()
