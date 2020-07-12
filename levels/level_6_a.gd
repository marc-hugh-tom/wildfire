extends "res://scripts/base_level.gd"

func get_start_money():
	return 6

func get_available_items():
	return [
		"Cigarette"
	]

func get_start_time_seconds():
	return 50

func get_next_level():
	return "level_6_b"

func get_tutorial_text():
	return("Fireworks can fly through burnt things?")

func get_music_path():
	return "level_2"
