extends "res://scripts/placeable.gd"

func get_placeable_name():
	return("plantkiller")

func get_cost():
	return(1)
	
func get_description():
	return("Kills trees, making them more flammable.")

func get_icon():
	return(load("res://assets/plant_killer.png"))
