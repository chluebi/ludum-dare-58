extends CharacterBody2D

@export var MAX_SPEED = 400
@export var ACCELERATION = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var acceleration_vec = Vector2.ZERO
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		acceleration_vec.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		acceleration_vec.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		acceleration_vec.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		acceleration_vec.y -= 1
		
	acceleration_vec = acceleration_vec.normalized()
	
	assert(delta * ACCELERATION <= 1) # make sure that we never extrapolate, i.e. go faster than max_speed
	velocity = lerp(velocity, acceleration_vec * MAX_SPEED, delta * ACCELERATION)
	
	move_and_slide()
