extends Node2D

signal quit
signal play_sound

func _ready():
	$menu.get_node("menu_button").connect(
		"button_up", self, "return_to_menu")

func return_to_menu():
	emit_signal("play_sound", "button_click")
	emit_signal("quit")
