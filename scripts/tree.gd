extends Node2D

onready var fsm = $fire_state_machine

onready var on_fire_start_texture = preload("res://assets/tree_fire_start.png")
onready var on_fire_spread_texture = preload("res://assets/tree_fire_full.png")

var pos

func _ready():
	fsm.connect("on_fire", self, "_on_fire")
	fsm.connect("spread", self, "_on_spread")

func init(coord):
	pos = coord

func _spread_callback(neighbour):
	fsm._on_fire_spread()

func _on_fire():
	$Sprite.set_texture(on_fire_start_texture)

func _on_spread():
	$Sprite.set_texture(on_fire_spread_texture)
