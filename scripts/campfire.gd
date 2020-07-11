extends "res://scripts/burnable.gd"

func get_initial_heat():
	return 1
	
func get_initial_flash_point():
	return 0
	
func get_initial_fuel():
	return 20

func get_placeable_name():
	return "campfire"

func get_cost():
	return 1

func get_description():
	return "a campfire"

func get_icon():
	return(load("res://assets/campfire.png"))
