extends "res://scripts/burnable.gd"

onready var destroyed_petrol_texture = preload("res://assets/petrol_destroyed.png")

func get_initial_heat():
	return 0
	
func get_initial_flash_point():
	return 1
	
func get_initial_fuel():
	return 2

func get_placeable_name():
	return "petrol"
	
func on_fuel_depleted():
	.on_fuel_depleted()
	$Sprite.set_texture(destroyed_petrol_texture)
	if has_node("Area2D"):
		$Area2D.queue_free()

func pump_out_fire():
	if not exploded:
		emit_signal("play_sound", "explosion")
	.pump_out_fire()

func get_cost():
	return 1

func get_description():
	return "I'm gonna be honest with you, it smells like pure gasoline."

func get_icon():
	return(load("res://assets/petrol.png"))

func get_directions():
	return [
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(1, 0),
		Vector2(0, -1),
		Vector2(-1, -1),
		Vector2(1, 1),
		Vector2(1, -1),
		Vector2(-1, 1),
		
		Vector2(-2, 0),
		Vector2(0, 2),
		Vector2(2, 0),
		Vector2(0, -2),
		Vector2(-2, -2),
		Vector2(2, 2),
		Vector2(2, -2),
		Vector2(-2, 2),
	]
