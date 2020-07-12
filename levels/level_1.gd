extends "res://scripts/base_level.gd"

func get_start_money():
	return 10

func get_available_items():
	return [
		"Plant Killer"
	]

func get_start_time_seconds():
	return 20

func get_next_level():
	return "level_2"

func get_tutorial_text():
	return("These trees don't light up very easily. Click the plant killer button, then click on the trees to kill them.")