extends Area2D


const WORLD_BOUND_MIN = Vector2(-1000, -1000)
const WORLD_BOUND_MAX = Vector2(1000, 1000)
const SPEED = 800.0
var direction = Vector2(1.0, 0)
var TIME_BETWEEN_ANIMATION_FRAMES = 0.2
var timer = 0.0
var animation_frame = 0
@onready var SPRITE = $sprite
static var PARTICLE_SCENE = preload("res://fireball_particles.tscn")
 

func _ready() -> void:
	body_entered.connect(on_collision)
	
func _process(delta: float) -> void:
	timer += delta
	if timer > TIME_BETWEEN_ANIMATION_FRAMES:
		timer -= TIME_BETWEEN_ANIMATION_FRAMES
		animation_frame += 1
		animation_frame %= 4
		SPRITE.frame = animation_frame
	position += direction * SPEED * delta
	if position.x < WORLD_BOUND_MIN.x or position.x > WORLD_BOUND_MAX.x:
		queue_free()
	elif position.y < WORLD_BOUND_MIN.y or position.y > WORLD_BOUND_MAX.y:
		queue_free()
	
func on_collision(body):
	var particles = PARTICLE_SCENE.instantiate()
	particles.position = position
	particles.direction = direction
	particles.emitting = true
	get_parent().add_child(particles)
	print("particles spawned", particles)
	queue_free()
