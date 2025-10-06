extends Area2D


const WORLD_BOUND_MIN = Vector2(-1000, -1000)
const WORLD_BOUND_MAX = Vector2(1000, 1000)
const SPEED = 800.0
var direction = Vector2(1.0, 0)
var TIME_BETWEEN_ANIMATION_FRAMES = 0.2
var timer = 0.0
var size = 0
var animation_frame = 0
var damage = 15
var is_enemy = false
@onready var SPRITE = $sprite
@onready var ENEMY_SPRITE = $enemy_sprite
static var PARTICLE_SCENE = preload("res://fireball_particles.tscn")


func frame_to_rect(animation_frame):
	var x = 4.0 * animation_frame
	return Rect2(x, 0, 4, 4)

func set_sprite_region():
	if is_enemy:
		ENEMY_SPRITE.frame = animation_frame
		return
	if size == 0:
		SPRITE.region_rect = Rect2(7, 1, 2, 2)
	elif size == 1:
		SPRITE.region_rect = frame_to_rect(animation_frame)
	else:
		SPRITE.region_rect = Rect2(5 * animation_frame + 16, 0, 5, 5)
		
func _ready() -> void:
	if is_enemy:
		collision_mask = 2
		SPRITE.visible = false
		ENEMY_SPRITE.visible = true
	body_entered.connect(on_collision)
	set_sprite_region()
	
	
func _process(delta: float) -> void:
	timer += delta
	if timer > TIME_BETWEEN_ANIMATION_FRAMES and (is_enemy or size > 0):
		timer -= TIME_BETWEEN_ANIMATION_FRAMES
		animation_frame += 1
		animation_frame %= 4
		set_sprite_region()
		#SPRITE.region_rect = frame_to_rect(animation_frame)
	position += direction * SPEED * delta
	if timer > 15.0:
		queue_free()
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
	var destroy = true
	var audio = $soft_audio
	if "health" in body:
		if size > 0:
			audio = $hard_audio
		if body.health.take_damage(damage * (1 + size)) and size > 0:
			#damage *= 2
			destroy = false
	# sometimes, the audio players are not ready when the collision happens, so this check avoids a crash
	if audio:
		remove_child(audio)
		get_parent().add_child(audio)
		audio.position = position
		audio.play()
		audio.finished.connect(audio.queue_free)
	
	if destroy:
		queue_free()
