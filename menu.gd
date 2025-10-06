extends CanvasLayer


var potion_scene: PackedScene = preload("res://item_sprite.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	render_potions([Constants.item_type.orange, Constants.item_type.blue, Constants.item_type.green])


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
		
