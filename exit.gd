extends Area2D


func _ready():
	body_entered.connect(leave_map)

func leave_map(body):
	print(body, " is leaving")
