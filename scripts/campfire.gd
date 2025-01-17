extends "res://scripts/burnable.gd"

onready var burnt_tree_texture = preload("res://assets/burnt_tree.png")

func get_initial_heat():
	return 5
	
func get_initial_flash_point():
	return 0
	
func get_initial_fuel():
	return 3
	
func on_fuel_depleted():
	.on_fuel_depleted()
	$Sprite.set_texture(burnt_tree_texture)

func get_placeable_name():
	return "campfire"

func get_cost():
	return 1

func get_description():
	return "a campfire"

func get_icon():
	return(load("res://assets/campfire.png"))
