extends Node2D

const FLAME = preload("res://nodes/burnable/flame.tscn")

var heat = 0
var flash_point = 3

func _ready():
	$Area2D.connect("area_entered", self, "_on_area_entered")
	
	$BurnTimer.connect("timeout", self, "_on_BurnTimer_timeout") 
	$BurnTimer.start()

func _on_area_entered(entity):	
	var collision_layer = entity.get_collision_layer()
	var layer_name = ProjectSettings.get_setting(
		str("layer_names/2d_physics/layer_", collision_layer))

	if layer_name == "flame":
		heat += 1
		
func _on_BurnTimer_timeout():
	if heat > flash_point:
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
			var flame = FLAME.instance()
			flame.set_direction(direction)
			add_child(flame)
