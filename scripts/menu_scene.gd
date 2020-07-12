extends Node2D

signal start_game
signal start_credits

signal play_sound

func _ready():
	$menu.get_node("vbox/start_button").connect(
		"button_up", self, "start_game")
	$menu.get_node("vbox/credits_button").connect(
		"button_up", self, "start_credits")

func start_game():
	emit_signal("play_sound", "button_click")
	emit_signal("start_game")

func start_credits():
	emit_signal("play_sound", "button_click")
	emit_signal("start_credits")
