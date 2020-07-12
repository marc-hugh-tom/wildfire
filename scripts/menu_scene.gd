extends Node2D

signal start_game
signal play_sound

func _ready():
	$menu.get_node("vbox/start_button").connect(
		"button_up", self, "start_game")

func start_game():
	emit_signal("play_sound", "button_click")
	emit_signal("start_game")
