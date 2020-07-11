extends "res://scripts/burnable.gd"

onready var burnt_tree_texture = preload("res://assets/burnt_tree.png")
onready var tree_fire_start_texture = preload("res://assets/tree_fire_start.png")
onready var tree_fire_full_texture = preload("res://assets/tree_fire_full.png")

func get_initial_heat():
	return 0
	
func get_initial_flash_point():
	return 4
	
func get_initial_fuel():
	return 5

func on_fuel_depleted():
	$Sprite.set_texture(burnt_tree_texture)

func get_placeable_name():
	return "tree"

func get_cost():
	return 1

func get_description():
	return "a tree"

func on_heat_incremented(heat):
	if heat == 1:
		$Sprite.set_texture(tree_fire_start_texture)
	elif heat >= 3:
		$Sprite.set_texture(tree_fire_full_texture)
