extends Area2D

const COLLISION = preload("res://poison_collision.tscn")
const PARTICLES = preload("res://poison_particles.tscn")

const DURATION = 3.0
var damage = 5
var evil = false

class EmittedPoint:
	var shape
	var particles
	var start_time
	func _init(time, pos, parent):
		start_time = time
		shape = COLLISION.instantiate()
		particles = PARTICLES.instantiate()
		shape.position = pos
		particles.position = pos
		if parent.evil:
			particles.material.set_shader_parameter("purple", Vector4(0.8, 0.2, 0.3, 0.8))
		parent.add_child.call_deferred(shape)
		parent.add_child.call_deferred(particles)
		
	func clean(time):
		if start_time + DURATION > time:
			return false
		shape.queue_free()
		particles.queue_free()
		return true

var points = []

var timer = 0

func clean(p):
	return !p.clean(timer)

func update_carrier(pos: Vector2):
	var new_point = EmittedPoint.new(timer, pos, self)
	points.push_back(new_point)


func poison_tick():
	points = points.filter(clean)
	var cols = get_overlapping_bodies()
	for c in cols:
		if "health" in c:
			c.health.take_damage(damage)

func set_strength(strength):
	damage = 5.0 + strength * 2.5

func _process(delta: float) -> void:
	timer += delta
