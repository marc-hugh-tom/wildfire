extends "res://scripts/base_level.gd"

func get_start_money():
	return 10

func get_available_items():
	return [ "Cigarette" ]

func get_start_time_seconds():
	return 20

func get_next_level():
	return "level_6"

func get_tutorial_text():
	return("Rube would be proud")