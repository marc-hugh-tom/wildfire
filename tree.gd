extends Node

onready var fsm = $fire_state_machine

var pos

func _ready():
	fsm.connect("on_fire", self, "_on_fire")

func init(coord):
	pos = coord

func _on_fire():
	print("tree is on fire!")
