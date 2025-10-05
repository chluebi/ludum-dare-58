class_name Constants
enum item_type {
	orange, yellow, green, blue, rainbow, purple, pink, empty,
	firestone, bone, slime, powder, mushroom, flower, none
}

static func random_potion() -> item_type:
	return randi_range(0, item_type.empty - 1) as item_type

static func is_drinkable_potion(i: item_type) -> bool:
	return 0 <= i and i < item_type.empty
