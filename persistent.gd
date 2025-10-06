extends Node

var number_of_runs = 0
var last_run_escaped = false

var tutorial_completed = false
var drunk: Array[Constants.item_type] = []
var escaped: Array[Constants.item_type] = []
var game_completed = false

var just_drunk: Array[Constants.item_type] = []
var just_escaped: Array[Constants.item_type] = []


func add_drunk(i: Constants.item_type):
	if i in drunk:
		return
	drunk.push_back(i)
	just_drunk.push_back(i)


func add_escaped(i: Constants.item_type):
	if i >= Constants.item_type.empty:
		return
	if i in escaped:
		return
	escaped.push_back(i)
	just_escaped.push_back(i)
