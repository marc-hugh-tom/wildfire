extends Node2D

signal quit

const debug_level = preload("res://nodes/main.tscn")

var current_level

var placement_cursor
var valid_cursor = preload("res://assets/ui/valid_position.png")

var current_item

func _ready():
	connect_ui_buttons()
	add_level(debug_level)
	display_placement_cursor()
	DEBUG()

func connect_ui_buttons():
	$hud.get_node("background/reset_buttons/menu").connect(
		"button_up", self, "emit_signal", ["quit"])

func add_level(level):
	current_level = level.instance()
	add_child(current_level)
	move_child(current_level, 0)

func display_placement_cursor():
	placement_cursor = Sprite.new()
	placement_cursor.set_centered(false)
	placement_cursor.texture = valid_cursor
	add_child(placement_cursor)

func _input(event):
	if event is InputEventMouseMotion:
		var tilemap = current_level.get_node("TileMap")
		var snapped_position = tilemap.map_to_world(
			tilemap.world_to_map(event.position))
		placement_cursor.set_position(snapped_position)
		validity_test(event.position)

func validity_test(world_position):
	print(current_level.callv(current_item.get_placeable_name() + "_validity", [world_position]))

func DEBUG():
	var plantkiller = preload("res://nodes/plantkiller.tscn")
	current_item = plantkiller.instance()
