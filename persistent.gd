extends Node

var tutorial_completed = false
var drunk: Array[Constants.item_type] = []
var escaped: Array[Constants.item_type] = []
var game_completed = false


func add_drunk(i: Constants.item_type):
	if i in drunk:
		return
	drunk.push_back(i)

func add_escaped(i: Constants.item_type):
	if i >= Constants.item_type.empty:
		return
	if i in escaped:
		return
	escaped.push_back(i)
