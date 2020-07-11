extends Node2D

onready var fsm = $fire_state_machine

var pos

func _ready():
	fsm.change_to("on_fire")

func init(coord):
	pos = coord

func _spread_callback(neighbour):
	fsm._on_fire_spread()
