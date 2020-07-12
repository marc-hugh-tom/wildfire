extends "res://scripts/base_level.gd"

func get_start_money():
	return 6

func get_available_items():
	return [
		"Plant Killer", "Ice Cube", "Petrol Can"
	]

func get_start_time_seconds():
	return 42

func get_next_level():
	return "level_10"

func get_tutorial_text():
	return("999.")
