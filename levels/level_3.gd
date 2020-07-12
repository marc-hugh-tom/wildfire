extends "res://scripts/base_level.gd"

func get_start_money():
	return 10

func get_available_items():
	return [
		"Plant Killer", "Petrol Can"
	]

func get_start_time_seconds():
	return 20

func get_next_level():
	return "level_4"

func get_tutorial_text():
	return("Some idiot has stuck a rock in the way! I'm sure petrol will be the solution.")
