extends Node2D

const debug_level = preload("res://nodes/main.tscn")

func _ready():
	var level = debug_level.instance()
	add_child(level)
