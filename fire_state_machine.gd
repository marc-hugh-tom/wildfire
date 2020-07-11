extends Node

class_name FireStateMachine

const DEBUG = true

var state: Object

var history = []

signal spread
signal on_fire

func _ready():
	state = get_child(0)
	_enter_state()

func change_to(new_state):
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()

func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()

func _enter_state():
	state.fsm = self
	if state.has_method("enter"):
		state.enter()

func _process(delta):
	state.fsm = self
	if state.has_method("process"):
		state.process(delta)

func spread():
	emit_signal("spread")

func _on_fire_spread():
	if state.name != "spread_fire":
		emit_signal("on_fire")
		if state.has_method("_on_fire_spread"):
			state._on_fire_spread()
