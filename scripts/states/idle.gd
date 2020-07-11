extends Node

const FireStateMachine = preload("res://scripts/fire_state_machine.gd")

var fsm: FireStateMachine

func _on_fire_spread():
	fsm.change_to("on_fire")
