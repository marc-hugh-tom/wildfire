extends "res://scripts/burnable.gd"

onready var burnt_tree_texture = preload("res://assets/burnt_tree.png")

func get_initial_heat():
	return 0
	
func get_initial_flash_point():
	return 0
	
func get_initial_fuel():
	return 2

func on_fuel_depleted():
	.on_fuel_depleted()
	$Sprite.set_texture(burnt_tree_texture)
	if has_node("Area2D"):
		$Area2D.queue_free()

func get_placeable_name():
	return "dry tree"

func get_cost():
	return 1

func get_description():
	return "a dry tree"

func get_icon():
	return(load("res://assets/dry_trees.png"))
