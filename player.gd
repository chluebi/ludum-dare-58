extends CharacterBody2D

@export var MAX_SPEED = 400
@export var ACCELERATION = 20
@onready var BOOK = $book
const BOOK_DISTANCE = 50
var FIREBALL_SCENE = preload("res://fireball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var aim_direction = (get_global_mouse_position() - position).normalized()
	BOOK.position = aim_direction * BOOK_DISTANCE
	if Input.is_action_just_pressed("shoot"):
		print("shooting fireball")
		var fireball = FIREBALL_SCENE.instantiate()
		fireball.position = position + BOOK.position
		fireball.direction = aim_direction
		get_parent().add_child(fireball)
	var acceleration_vec = Vector2.ZERO
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		acceleration_vec.x += 1
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		acceleration_vec.x -= 1
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		acceleration_vec.y += 1
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		acceleration_vec.y -= 1
	
	if acceleration_vec.length_squared() > 1:
		acceleration_vec = acceleration_vec.normalized()
	
	velocity = lerp(velocity, acceleration_vec * MAX_SPEED, delta * ACCELERATION)
	if (velocity.length() > MAX_SPEED):
		velocity = velocity.normalized() * MAX_SPEED # make sure that we never extrapolate, i.e. go faster than max_speed
	
	move_and_slide()
