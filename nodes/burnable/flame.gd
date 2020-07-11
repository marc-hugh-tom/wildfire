extends Node2D

var speed = 3
var direction
var target_position

func set_direction(d):
	direction = d
	target_position = d * 32

func _process(delta):
	position = lerp(position, target_position, delta * speed)
	if position.distance_to(target_position) < 1:
		queue_free()
