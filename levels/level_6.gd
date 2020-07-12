extends "res://scripts/base_level.gd"

func get_start_money():
	return 6

func get_available_items():
	return [
		"Plant Killer", "Ice Cube"
	]

func get_start_time_seconds():
	return 20

func get_next_level():
	return "level_7"

func get_tutorial_text():
	return("I don't want to burn down my house, I just want to chill.")

func get_music_path():
	return "level_2"
