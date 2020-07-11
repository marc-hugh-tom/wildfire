extends "res://scripts/placeable.gd"

func get_placeable_name():
	return "ice_block"

func get_cost():
	return 1

func get_description():
	return "an ice block"

func get_icon():
	return(load("res://assets/icecube.png"))
