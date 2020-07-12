extends Node2D

func _ready():
	if has_node("Area2D"):
		$Area2D.connect("area_entered", self, "_on_area_entered")

func _on_area_entered(entity):	
	if entity.get_collision_layer_bit(0):
		entity.queue_free()
