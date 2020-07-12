extends Node2D

const play_scene = preload("res://nodes/play_scene.tscn")
const menu_scene = preload("res://nodes/menu_scene.tscn")
#const credits_scene = preload("res://nodes/credits_scene.tscn")
const scene_transition = preload("res://nodes/scene_transition.tscn")
const audio_manager = preload("res://nodes/audio_manager.tscn")

var audio

func _ready():
	audio = audio_manager.instance()
	add_child(audio)
	set_pause_mode(PAUSE_MODE_PROCESS)
	var transition = scene_transition.instance()
	transition.set_to_black()
	add_child(transition)
	deferred_start_menu()

func start_new_game():
	if not has_node("scene_transition"):
		initiate_fade_to_black("deferred_new_game")

func deferred_new_game():
	clear_scene()
	var new_game = play_scene.instance()
	new_game.connect("quit", self, "start_menu")
	new_game.connect("play_sound", self, "play_sound")
	add_child(new_game)
	initiate_fade_to_transparent("remove_transition_overlay")

func start_menu():
	if not has_node("scene_transition"):
		initiate_fade_to_black("deferred_start_menu")

func deferred_start_menu():
	clear_scene()
	var menu = menu_scene.instance()
	menu.connect("start_game", self, "start_new_game")
	add_child(menu)
	initiate_fade_to_transparent("remove_transition_overlay")

func clear_scene():
	for child in get_children():
		if not child == audio:
			child.free()

func initiate_fade_to_black(input_callback_str):
	var transition = scene_transition.instance()
	transition.set_to_transparent()
	transition.connect("transition_finished", self, "transition_finished_callback")
	add_child(transition)
	transition.fade_to_black(input_callback_str)

func initiate_fade_to_transparent(input_callback_str):
	var transition = scene_transition.instance()
	transition.set_to_black()
	transition.connect("transition_finished", self, "transition_finished_callback")
	add_child(transition)
	transition.fade_to_transparent(input_callback_str)

func transition_finished_callback(callback_str):
	call_deferred(callback_str)

func remove_transition_overlay():
	$scene_transition.queue_free()

func play_sound(sound_name):
	audio.play_sound(sound_name)
