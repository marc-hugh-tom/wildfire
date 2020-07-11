extends Node2D

signal quit

const debug_level = preload("res://nodes/main.tscn")

var current_level

var placement_cursor
var valid_cursor = preload("res://assets/ui/valid_position.png")
var invalid_cursor = preload("res://assets/ui/invalid_position.png")

var current_item

func _ready():
	connect_ui_buttons()
	set_pause_mode(PAUSE_MODE_PROCESS)
	add_level(debug_level)
	display_placement_cursor()

func connect_ui_buttons():
	$hud.get_node("background/reset_buttons/menu").connect(
		"button_up", self, "emit_signal", ["quit"])
	$hud.get_node("background/reset_buttons/reset").connect(
		"button_up", self, "add_level", [debug_level])
	$hud.get_node("background/simulation_buttons/start_stop").connect(
		"button_up", self, "toggle_pause")

func add_level(level):
	if not current_level == null:
		current_level.queue_free()
	current_level = level.instance()
	current_level.connect("treehouse_burnt", self, "on_treehouse_burnt")
	init_item_buttons(current_level.items)
	add_child(current_level)
	move_child(current_level, 0)
	current_level.set_pause_mode(PAUSE_MODE_STOP)
	get_tree().set_pause(true)
	
func on_treehouse_burnt():
	print("on treehouse burnt")

func display_placement_cursor():
	placement_cursor = Sprite.new()
	placement_cursor.set_centered(false)
	placement_cursor.texture = valid_cursor
	add_child(placement_cursor)

func _input(event):
	if event is InputEventMouseMotion:
		if current_item:
			update_placement_cursor(event.position)
	if event is InputEventMouseButton:
		if not event.is_pressed():
			if current_item:
				if validity_test(event.position):
					apply_item(event.position)

func update_placement_cursor(event_position):
	var tilemap = current_level.get_node("TileMap")
	var snapped_position = tilemap.map_to_world(
		tilemap.world_to_map(event_position))
	placement_cursor.set_position(snapped_position)
	if validity_test(event_position):
		placement_cursor.texture = valid_cursor
	else:
		placement_cursor.texture = invalid_cursor

func validity_test(world_position):
	return(current_level.callv(current_item.get_placeable_name() + "_validity", [world_position]))

func apply_item(world_position):
	return(current_level.callv(current_item.get_placeable_name() + "_application", [world_position]))

func toggle_pause():
	get_tree().set_pause(!get_tree().is_paused())

func init_item_buttons(item_dict):
	for child in $hud.get_node("background/item_buttons").get_children():
		child.queue_free()
	for item_name in item_dict:
		var button = Button.new()
		button.set_text(item_name)
		button.connect("button_up", self, "item_swap_callback",
			[item_name])
		$hud.get_node("background/item_buttons").add_child(button)

func item_swap_callback(item_name):
	current_item = current_level.items[item_name].instance()
