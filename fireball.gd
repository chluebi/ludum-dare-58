extends Area2D


const WORLD_BOUND_MIN = Vector2(-1000, -1000)
const WORLD_BOUND_MAX = Vector2(1000, 1000)
const SPEED = 800.0
var direction = Vector2(1.0, 0)
var TIME_BETWEEN_ANIMATION_FRAMES = 0.2
var timer = 0.0
var big = false
var animation_frame = 0
@onready var SPRITE = $sprite
static var PARTICLE_SCENE = preload("res://fireball_particles.tscn")
 
func frame_to_rect(animation_frame):
	var x = 4.0 * animation_frame
	return Rect2(x, 0, 4, 4)
func _ready() -> void:
	body_entered.connect(on_collision)
	SPRITE.region_enabled = true

	if !big:
		SPRITE.region_rect = Rect2(7, 1, 2, 2)
	else:
		SPRITE.region_rect = frame_to_rect(0)
	
func _process(delta: float) -> void:
	timer += delta
	if timer > TIME_BETWEEN_ANIMATION_FRAMES and big:
		timer -= TIME_BETWEEN_ANIMATION_FRAMES
		animation_frame += 1
		animation_frame %= 4
		SPRITE.region_rect = frame_to_rect(animation_frame)
	position += direction * SPEED * delta
	#if position.x < WORLD_BOUND_MIN.x or position.x > WORLD_BOUND_MAX.x:
		#queue_free()
	#elif position.y < WORLD_BOUND_MIN.y or position.y > WORLD_BOUND_MAX.y:
		#queue_free()
	
func on_collision(body):
	if "health" in body:
		body.health.take_damage(10)
	var particles = PARTICLE_SCENE.instantiate()
	particles.position = position
	particles.direction = direction
	particles.emitting = true
	get_parent().add_child(particles)
	queue_free()
