extends "res://scripts/base_level.gd"

func get_start_money():
	return 99

func get_available_items():
	return [
		"Plant Killer", "Cigarette", "Petrol Can", "Ice Cube", "Firework"
	]

func get_start_time_seconds():
	return 99

func get_next_level():
	return null