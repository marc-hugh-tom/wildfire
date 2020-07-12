extends "res://scripts/burnable.gd"

onready var burnt_tree_texture = preload("res://assets/burnt_tree.png")

func get_initial_heat():
	return 0
	
func get_initial_flash_point():
	return 4
	
func get_initial_fuel():
	return 4

func on_fuel_depleted():
	.on_fuel_depleted()
	$Sprite.set_texture(burnt_tree_texture)
	if has_node("Area2D"):
		$Area2D.queue_free()

func get_placeable_name():
	return "tree"

func get_cost():
	return 1

func get_description():
	return "a tree"

func get_icon():
	return(load("res://assets/tree.png"))
