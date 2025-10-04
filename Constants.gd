class_name Constants
enum potion_type {
	orange, yellow, green, blue, rainbow, purple, pink,
	FINAL
}

static func random_type() -> potion_type:
	return randi_range(0, potion_type.FINAL - 1)
