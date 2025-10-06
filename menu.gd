extends CanvasLayer

@onready var MAIN_SCENE = load("res://main.tscn")
var potion_scene: PackedScene = preload("res://item_sprite.tscn")
#var potions: Array[Constants.item_type] = [Constants.item_type.orange, Constants.item_type.blue, Constants.item_type.green]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("after leaving: ", Persistent.tutorial_completed)
	print(Persistent.escaped)
	print(Persistent.drunk)
	render_potions(Persistent.escaped)
	var t = Timer.new()
	add_child(t)
	t.timeout.connect(start_game)
	t.start(2.0)

func start_game():
	get_tree().change_scene_to_packed(MAIN_SCENE)
	#var main = MAIN_SCENE.instantiate()
	#get_tree().root.add_child.call_deferred(main)
	#queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const scale_factor = Vector2(1600/96, 1600/96)

func render_potions(potions: Array[Constants.item_type]) -> void:
	var container = $PanelContainer
	
	for i in range(len(potions)):
		var child = potion_scene.instantiate()
		child.scale = Vector2(1, 1) * scale_factor
		child.position = Vector2(20 + i * scale_factor.x * 4.2,58)
		child.set_item_type(potions[i])
		
		container.add_child(child)
		
