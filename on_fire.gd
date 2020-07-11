extends Node

var fsm: FireStateMachine
var spread_threshold = 1.0

func process(delta):
	if spread_threshold <= 0.0:
		fsm.spread()
		fsm.change_to("spread_fire")
	spread_threshold -= delta
