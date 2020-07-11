extends Node2D

var speed = 3
var direction
var target_position

func _ready():
	$Area2D.connect("area_entered", self, "_on_area_entered")

func set_direction(d):
	direction = d
	target_position = d * 32

func _process(delta):
	position = lerp(position, target_position, delta * speed)
	if position.distance_to(target_position) < 1:
		queue_free()

func _on_area_entered(entity):
	var collision_layer = entity.get_collision_layer()
	var layer_name = ProjectSettings.get_setting(
		str("layer_names/2d_physics/layer_", collision_layer))

	if layer_name == "ice":
		queue_free()
