extends "res://scripts/base_level.gd"

func get_start_money():
	return 10

func get_available_items():
	return [
		"Plant Killer", "Cigarette", "Petrol Can", "Ice cube"
	]

func get_start_time_seconds():
	return 30

func get_next_level():
	return "level_2"
