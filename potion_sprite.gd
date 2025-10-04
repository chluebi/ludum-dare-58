extends Sprite2D

func set_potion_type(t: Constants.potion_type):
	var x = t * 4.0 + 0.1
	region_rect = Rect2(x, 0, 4.9, 8.0)
