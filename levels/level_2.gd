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
	return "level_3"

func get_tutorial_text():
	return("Bloody trees didn't grow back very well, I'm sure there's something around here to get the firework lit...")
