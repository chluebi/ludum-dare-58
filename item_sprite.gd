extends Sprite2D

func set_potion_type(t: Constants.item_type):
	set_item_type(t)


func set_item_type(t: Constants.item_type):
	region_enabled = true
	if t <= Constants.item_type.empty:
		var x = t * 4.0 + 0.1
		region_rect = Rect2(x, 10.0, 4.8, 8.0)
	else:
		var x = Constants.item_type.empty * 4.0 + 0.1
		var y = (t - Constants.item_type.empty) * 8.0 + 10.1
		region_rect = Rect2(x, y, 4.9, 7.9)
