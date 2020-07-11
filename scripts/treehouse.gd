extends Node2D

onready var fsm = $fire_state_machine

onready var on_fire_texture = preload("res://assets/treehouse_fire.png")

var pos

func _ready():
	fsm.connect("on_fire", self, "_on_fire")

func init(coord):
	pos = coord

func _on_fire():
	$Sprite.set_texture(on_fire_texture)
	print("treehouse ", pos, " is on fire!")
