extends "res://scripts/placeable.gd"

var firework = preload("res://nodes/firework.tscn")

signal target_hit

func _ready():
	$Area2D.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(entity):
	var collision_layer = entity.get_collision_layer()
	var layer_name = ProjectSettings.get_setting(
		str("layer_names/2d_physics/layer_", collision_layer))
	
	# i cant figure out collision layers :(
	if entity.get_parent().has_method("im_a_firework"):
		emit_signal("target_hit")

func get_placeable_name():
	return "target"

func get_cost():
	return 1
	
func get_description():
	return "a target"

func get_icon():
	return(load("res://assets/target.png"))
