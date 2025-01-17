extends "res://scripts/burnable.gd"

func get_initial_heat():
	return 1
	
func get_initial_flash_point():
	return 0
	
func get_initial_fuel():
	return 2

func get_placeable_name():
	return "cigarette"

func get_cost():
	return 1

func get_description():
	return "A carelessly discarded cigarette."
	
func on_fuel_depleted():
	.on_fuel_depleted()
	$AnimatedSprite.set_animation("burnt")
	if has_node("Area2D"):
		$Area2D.queue_free()

func get_icon():
	return(load("res://assets/cigarette/cigarette1.png"))

func get_directions():
	return [
		Vector2(-1, 0),
		Vector2(-1, 0),
	]

func get_flame_offset():
	return Vector2(-16, 2)

func get_fire_offset():
	return Vector2(-16, -4)
