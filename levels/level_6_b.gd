extends "res://scripts/base_level.gd"

func get_start_money():
	return 6

func get_available_items():
	return [
		"Ice Cube", "Plant Killer"
	]

func get_start_time_seconds():
	return 50

func get_next_level():
	return "level_7"

func get_tutorial_text():
	return("People say I have a short fuse.")

func get_music_path():
	return "level_2"
