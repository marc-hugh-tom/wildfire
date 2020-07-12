extends "res://scripts/placeable.gd"

const WATER = preload("res://nodes/water.tscn")

func _ready():
	if has_node("Area2D"):
		$Area2D.connect("area_entered", self, "_on_area_entered")

func get_placeable_name():
	return "ice_block"

func get_cost():
	return 1

func get_description():
	return "an ice block"

func get_icon():
	return(load("res://assets/icecube.png"))

func _on_area_entered(entity):
	if is_a_parent_of(entity):
		return

	if entity.get_collision_layer_bit(0):
		var directions = [
			Vector2(-1, 0),
			Vector2(0, 1),
			Vector2(1, 0),
			Vector2(0, -1),
			Vector2(-1, -1),
			Vector2(1, 1),
			Vector2(1, -1),
			Vector2(-1, 1)
		]
		for direction in directions:
			var water = WATER.instance()
			water.set_position(position+Vector2(16,16))
			water.set_direction(direction)
			get_parent().call_deferred("add_child", water)
		queue_free()
