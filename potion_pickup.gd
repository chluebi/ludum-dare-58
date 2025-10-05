extends RigidBody2D

@export var type: Constants.item_type
@onready var pickup = $Pickup

var throw_cooldown = 0

func _ready() -> void:
	$sprite.set_item_type(type)
	pickup.body_entered.connect(on_pickup)
	
func _process(delta: float) -> void:
	throw_cooldown -= delta

const DRAG_COEFFICIENT = 0.001

# drag
func _integrate_forces(state):
	var velocity = state.linear_velocity
	var speed = velocity.length()
	var drag_magnitude = DRAG_COEFFICIENT * speed * speed 
	var drag_direction = -velocity.normalized()
	var drag_force = drag_direction * drag_magnitude
	state.apply_central_force(drag_force)


func set_potion_type(t: Constants.item_type):
	type = t
	$sprite.set_item_type(t)


func on_pickup(body: Node):
	if body.has_method("on_potion_pickup") and throw_cooldown <= 0:
		body.on_potion_pickup(self)
