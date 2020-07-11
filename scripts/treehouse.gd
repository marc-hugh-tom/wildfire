extends "res://scripts/burnable.gd"

onready var treehouse_fire_texture = preload("res://assets/treehouse_fire.png")

signal treehouse_burnt

func get_initial_heat():
	return 0
	
func get_initial_flash_point():
	return 4
	
func get_initial_fuel():
	return 5

func get_placeable_name():
	return "treehouse"

func get_cost():
	return 1

func get_description():
	return "a treehouse"

func on_heat_incremented(heat):
	if heat == 1:
		$Sprite.set_texture(treehouse_fire_texture)
		emit_signal("treehouse_burnt")
