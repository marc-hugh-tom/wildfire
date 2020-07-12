extends "res://scripts/base_level.gd"

func get_start_money():
	return 12

func get_available_items():
	return [
		"Ice Cube", "Firework", "Petrol Can"
	]

func get_start_time_seconds():
	return 20

func get_next_level():
	return "level_9"

func get_tutorial_text():
	return("You're on your own!")

func get_music_path():
	return "level_1"
