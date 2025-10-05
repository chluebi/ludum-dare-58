extends Area2D


const WORLD_BOUND_MIN = Vector2(-1000, -1000)
const WORLD_BOUND_MAX = Vector2(1000, 1000)
const SPEED = 800.0
var direction = Vector2(1.0, 0)
var TIME_BETWEEN_ANIMATION_FRAMES = 0.2
var timer = 0.0
var size = 0
var animation_frame = 0
var damage = 10
@onready var SPRITE = $sprite
static var PARTICLE_SCENE = preload("res://fireball_particles.tscn")


func frame_to_rect(animation_frame):
	var x = 4.0 * animation_frame
	return Rect2(x, 0, 4, 4)

func set_sprite_region():
	if size == 0:
		SPRITE.region_rect = Rect2(7, 1, 2, 2)
	elif size == 1:
		SPRITE.region_rect = frame_to_rect(0)
	else:
		SPRITE.region_rect = Rect2(5 * animation_frame + 16, 0, 5, 5)
		
func _ready() -> void:
	body_entered.connect(on_collision)
	SPRITE.region_enabled = true
	set_sprite_region()
	
	
func _process(delta: float) -> void:
	timer += delta
	if timer > TIME_BETWEEN_ANIMATION_FRAMES and size > 0:
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
	var particles = PARTICLE_SCENE.instantiate()
	particles.position = position
	particles.direction = direction
	particles.emitting = true
	get_parent().get_parent().add_child(particles)
	var audio
	if size > 0:
		audio = $hard_audio
	else:
		audio = $soft_audio
	if "health" in body:
		if body.health.take_damage(damage * (1 + size)) and size > 0:
			damage *= 2
			audio.play()
			return
	# sometimes, the audio players are not ready when the collision happens, so this check avoids a crash
	if audio:
		remove_child(audio)
		get_parent().add_child(audio)
		audio.position = position
		audio.play()
		audio.finished.connect(audio.queue_free)
	queue_free()
