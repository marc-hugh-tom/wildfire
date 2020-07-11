extends Node2D

signal quit

const debug_level = preload("res://nodes/main.tscn")

func _ready():
	connect_ui_buttons()
	add_level(debug_level)

func connect_ui_buttons():
	$hud.get_node("background/buttons/menu").connect(
		"button_up", self, "emit_signal", ["quit"])

func add_level(level):
	var unpacked_level = level.instance()
	add_child(unpacked_level)
	move_child(unpacked_level, 0)
