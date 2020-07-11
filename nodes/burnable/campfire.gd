extends Node2D

const FLAME = preload("res://nodes/burnable/flame.tscn")

func _ready():
	$BurnTimer.connect("timeout", self, "_on_BurnTimer_timeout") 
	$BurnTimer.start()

func _on_BurnTimer_timeout():
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
