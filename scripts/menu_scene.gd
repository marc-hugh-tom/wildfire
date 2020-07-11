extends Node2D

signal start_game

func _ready():
	$menu.get_node("vbox/start_button").connect(
		"button_up", self, "emit_signal", ["start_game"])
