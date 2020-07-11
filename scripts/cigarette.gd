extends "res://scripts/burnable.gd"

func get_initial_heat():
	return 1
	
func get_initial_flash_point():
	return 0
	
func get_initial_fuel():
	return 3

func get_placeable_name():
	return "cigarette"

func get_cost():
	return 1

func get_description():
	return "A carelessly discarded cigarette."

func get_icon():
	return(load("res://assets/cigarette/cigarette1.png"))

func get_directions():
	return [
		Vector2(0, -1),
		Vector2(0, -1),
	]
