class_name Constants
enum item_type {
	orange, yellow, green, blue, rainbow, purple, pink, empty
}

static func random_potion() -> item_type:
	return randi_range(0, item_type.empty - 1)
