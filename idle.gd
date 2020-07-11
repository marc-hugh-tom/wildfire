extends Node

var fsm: FireStateMachine

func _on_fire_spread():
	fsm.change_to("on_fire")
