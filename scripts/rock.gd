extends "res://scripts/placeable.gd"

func _ready():
	if has_node("Area2D"):
		$Area2D.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(entity):	
	if entity.get_collision_layer_bit(0):
		entity.queue_free()
		
func get_placeable_name():
	return "rock"

func get_cost():
	return 1
	
func get_description():
	return "a rock"

func get_icon():
	return(load("res://assets/rock.png"))
