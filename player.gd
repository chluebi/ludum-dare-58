extends CharacterBody2D

@export var MAX_SPEED: int = 400
@export var ACCELERATION = 20
@onready var BOOK = $book
const BOOK_DISTANCE = 50
const FIREBALL_SCENE = preload("res://fireball.tscn")
const POTION_SCENE = preload("res://potion_pickup.tscn")
const HEALTH_SCRIPT = preload("res://health.gd")
const PLAYER_DEATH_SCRIPT = preload("res://death.gd")

const THROW_FORCE = 300
const ATTACK_INTERVAL = 0.7
var attack_timer = 0.0

var health = HEALTH_SCRIPT.new(100)
@onready var EFFECT_MANAGER = $"../../effect_manager"
@onready var INVENTORY_MANAGER = $"../../inventory_manager"

var is_drinking: bool = false

func on_death():
	print("player died, game is over")
	var l = func():
		$CollisionShape2D.disabled = true
		set_physics_process(false)
		set_script(PLAYER_DEATH_SCRIPT)
	l.call_deferred()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.death_signal.connect(on_death)
	health.health_percentage.connect($healthbar.set_health_percentage)
	$healthbar.set_health_percentage(1.0)

func spawn_fireball(aim_direction):
	var fireball = FIREBALL_SCENE.instantiate()
	fireball.position = position + BOOK.position
	fireball.direction = aim_direction
	var strength_bonus = EFFECT_MANAGER.activity_strength(Constants.item_type.orange)
	fireball.size = strength_bonus
	get_parent().add_child(fireball)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health.animate_damage(self, delta)
	var aim_direction = (get_global_mouse_position() - position).normalized()
	BOOK.position = aim_direction * BOOK_DISTANCE
	attack_timer += delta
	if Input.is_action_just_pressed("drink"):
		is_drinking = true
	if Input.is_action_just_released("drink"):
		is_drinking = false
		
	if Input.is_action_just_pressed("throw"):
		var item = INVENTORY_MANAGER.remove_current_item()
		if item != null:
			var pot: RigidBody2D = POTION_SCENE.instantiate()
			pot.position = position + BOOK.position * 0.2
			pot.apply_impulse(BOOK.position.normalized() * THROW_FORCE)
			pot.set_potion_type(item)
			pot.throw_cooldown = 1
			get_parent().add_child(pot)
	
	if Input.is_action_pressed("shoot"):
		if attack_timer >= ATTACK_INTERVAL:
			spawn_fireball(aim_direction)
			attack_timer = 0
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
	
	var effective_max = MAX_SPEED
	var mul = 1 + 0.5 * float(EFFECT_MANAGER.activity_strength(Constants.item_type.yellow))
	#if EFFECT_MANAGER.is_active(Constants.potion_type.yellow):
	effective_max *= mul
	velocity = lerp(velocity, acceleration_vec * effective_max, delta * ACCELERATION)
	if (velocity.length() > effective_max):
		velocity = velocity.normalized() * effective_max # make sure that we never extrapolate, i.e. go faster than max_speed
	
	var regen = float(EFFECT_MANAGER.activity_strength(Constants.item_type.pink))
	if regen > 0:
		health.heal_damage(regen * delta * 15)
	move_and_slide()

func on_potion_pickup(pot):
	var successful_pickup = INVENTORY_MANAGER.pickup_item(pot.type)
	if successful_pickup:
		pot.queue_free()
	elif is_drinking:
		INVENTORY_MANAGER.drink_from_ground(pot.type)
		pot.queue_free()
