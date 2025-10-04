extends Node2D


@onready var cur = $current
@onready var max = $max

func set_health_percentage(percent: float):
	percent = clampf(percent, 0, 1)
	cur.points[1].x = percent * (max.points[1].x - max.points[0].x) + max.points[0].x

func set_color_enemy():
	cur.default_color = Color8(222, 99, 38)
