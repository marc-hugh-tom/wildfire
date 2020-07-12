extends Node2D

signal quit
signal play_sound
signal play_music

const first_level = preload("res://levels/level_1.tscn")

var packaged_current_level = first_level
var current_level

var placement_cursor
var valid_cursor = preload("res://assets/ui/valid_position.png")
var invalid_cursor = preload("res://assets/ui/invalid_position.png")

var current_item

var action_list = []

var current_money

var item_button_dict = {}

func _ready():
	connect_ui_buttons()
	set_pause_mode(PAUSE_MODE_PROCESS)
	add_level(packaged_current_level)
	init_placement_cursor()
	init_next_level_button()

func connect_ui_buttons():
	$hud.get_node("background/reset_buttons/menu").connect(
		"button_up", self, "menu_button_callback")
	$hud.get_node("background/reset_buttons/reset").connect(
		"button_up", self, "completely_reset_level")
	$hud.get_node("background/simulation_buttons/start_stop").connect(
		"button_up", self, "start_stop")
	$hud.get_node("background/simulation_buttons/undo").connect(
		"button_up", self, "undo")

func menu_button_callback():
	emit_signal("play_sound", "button_click")
	emit_signal("quit")

func add_level(level):
	hide_messages()
	if not current_level == null:
		current_level.queue_free()
	current_level = level.instance()
	current_level.connect("treehouse_burnt", self, "on_treehouse_burnt")
	current_level.connect("target_hit", self, "on_success")
	current_level.connect("play_sound", self, "play_sound")
	init_item_buttons(current_level.init_items())
	add_child(current_level)
	move_child(current_level, 0)
	current_level.set_pause_mode(PAUSE_MODE_STOP)
	get_tree().set_pause(true)
	current_money = current_level.get_start_money()
	update_money()
	init_timer(current_level.get_start_time_seconds())
	init_tutorial_text()
	set_play_stop_to_play()
	emit_signal("play_music", current_level.get_music_path())

func init_tutorial_text():
	var text = current_level.get_tutorial_text()
	if text == "":
		$hud/tutorial_text.set_visible(false)
	else:
		$hud/tutorial_text.set_text(text)
		$hud/tutorial_text.set_visible(true)

func hide_messages():
	$hud/time_message.set_visible(false)
	$hud/lose_message.set_visible(false)
	$hud/win_message.set_visible(false)

func completely_reset_level():
	emit_signal("play_sound", "button_click")
	action_list = []
	add_level(packaged_current_level)

func on_treehouse_burnt():
	$Timer.set_paused(true)
	$hud/background/reset_buttons/reset.set_disabled(false)
	emit_signal("play_sound", "aww")
	$hud/lose_message.set_visible(true)

func on_success():
	$Timer.set_paused(true)
	$hud/background/reset_buttons/reset.set_disabled(false)
	emit_signal("play_sound", "woo")
	$hud/win_message.set_visible(true)

func init_next_level_button():
	$hud/win_message/hbox/margin/next_level.connect("button_up", self, "go_to_next_level")

func go_to_next_level():
	emit_signal("play_sound", "button_click")
	$hud/background/simulation_buttons/undo.set_disabled(false)
	action_list = []
	packaged_current_level = load("res://levels/" + current_level.get_next_level() + ".tscn")
	add_level(packaged_current_level)

func init_placement_cursor():
	placement_cursor = Node2D.new()
	var sprite = Sprite.new()
	sprite.set_centered(false)
	sprite.texture = valid_cursor
	sprite.set_name("Sprite")
	sprite.set_modulate(Color(1, 1, 1, 0.5))
	placement_cursor.set_visible(false)
	placement_cursor.add_child(sprite)
	placement_cursor.set_name("Cursor")
	add_child(placement_cursor)

func _input(event):
	if event is InputEventMouseMotion:
		update_placement_cursor(event.position)
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.is_pressed():
			if world_position_on_map(event.position):
				if current_item:
					if validity_test(event.position):
						emit_signal("play_sound", "valid")
						apply_and_record_item(event.position)
					else:
						emit_signal("play_sound", "invalid")

# Tests if a position is on the map. If false, it's on the UI
func world_position_on_map(world_position):
	return(not $hud.get_node("background").get_rect().has_point(world_position)
		and not $hud.get_node("timer").get_rect().has_point(world_position))

func update_placement_cursor(event_position):
	if world_position_on_map(event_position):
		if not current_item == null:
			var tilemap = current_level.get_node("TileMap")
			var snapped_position = tilemap.map_to_world(
				tilemap.world_to_map(event_position))
			placement_cursor.set_position(snapped_position)
			placement_cursor.set_visible(true)
			if validity_test(event_position):
				placement_cursor.get_node("Sprite").texture = valid_cursor
			else:
				placement_cursor.get_node("Sprite").texture = invalid_cursor
		else:
			placement_cursor.set_visible(false)
	else:
		placement_cursor.set_visible(false)

func validity_test(world_position):
	return(current_level.callv(current_item.get_placeable_name() + "_validity", [world_position]))

func apply_and_record_item(world_position):
	var item_rotation = 0
	if placement_cursor.has_node("Icon"):
		if placement_cursor.get_node("Icon").has_node("Rotatable"):
			item_rotation = placement_cursor.get_node("Icon").get_node("Rotatable")._rotation
	action_list.append(
		{
			"item": current_item,
			"position": world_position,
			"item_rotation": item_rotation
		}
	)
	apply_item(current_item, world_position, item_rotation)

func reset_level_and_apply_action_list():
	add_level(packaged_current_level)
	for action in action_list:
		apply_item(action["item"], action["position"], action["item_rotation"])

func apply_item(item, world_position, item_rotation):
	current_money -= item.get_cost()
	update_money()
	current_level.callv(item.get_placeable_name() + "_application",
		[world_position, item_rotation])

func start_stop():
	emit_signal("play_sound", "button_click")
	if get_tree().is_paused():
		disable_item_buttons()
		$hud/background/simulation_buttons/undo.set_disabled(true)
		$hud/background/reset_buttons/reset.set_disabled(true)
		get_tree().set_pause(false)
		$Timer.set_paused(false)
		$Timer.start()
		set_play_stop_to_stop()
	else:
		get_tree().set_pause(true)
		$hud/background/simulation_buttons/undo.set_disabled(false)
		$hud/background/reset_buttons/reset.set_disabled(false)
		reset_level_and_apply_action_list()

func undo():
	emit_signal("play_sound", "button_click")
	action_list.pop_back()
	reset_level_and_apply_action_list()

func init_item_buttons(item_dict):
	item_button_dict = {}
	for child in $hud.get_node("background/item_buttons").get_children():
		child.queue_free()
	for item_name in item_dict:
		var item_instance = item_dict[item_name].instance()
		var button = Button.new()
		button.set_text(item_name)
		button.set_button_icon(item_instance.get_icon())
		button.connect("button_up", self, "item_swap_callback",
			[item_name])
		$hud.get_node("background/item_buttons").add_child(button)
		item_button_dict[item_instance.get_placeable_name()] = {
			"button": button,
			"cost": item_instance.get_cost()
		}

func item_swap_callback(item_name):
	emit_signal("play_sound", "button_click")
	current_item = current_level.init_items()[item_name].instance()
	var icon = current_item.duplicate()
	if icon.has_node("Rotatable"):
		icon.position += Vector2(16, 16)
	icon.name = "Icon"
	if placement_cursor.has_node("Icon"):
		var node_to_delete = placement_cursor.get_node("Icon")
		placement_cursor.remove_child(node_to_delete)
		node_to_delete.queue_free()
	placement_cursor.add_child(icon)

func update_money():
	$hud.get_node("money").set_text("£" + str(current_money))
	update_item_buttons()

func update_item_buttons():
	for item_name in item_button_dict:
		if item_button_dict[item_name]["cost"] > current_money:
			item_button_dict[item_name]["button"].set_disabled(true)
			if not current_item == null and item_name == current_item.get_placeable_name():
				current_item = null
		else:
			item_button_dict[item_name]["button"].set_disabled(false)

func disable_item_buttons():
	current_item = null
	for item_name in item_button_dict:
		item_button_dict[item_name]["button"].set_disabled(true)

func set_play_stop_to_stop():
	var button = $hud.get_node("background/simulation_buttons/start_stop")
	button.set_text("Stop")
	button.set_button_icon(load("res://assets/ui/stop_icon.png"))

func set_play_stop_to_play():
	var button = $hud.get_node("background/simulation_buttons/start_stop")
	button.set_text("Play")
	button.set_button_icon(load("res://assets/ui/play_icon.png"))

func init_timer(time):
	if has_node("Timer"):
		var timer_to_delete = get_node("Timer")
		remove_child(timer_to_delete)
		timer_to_delete.queue_free()
	var timer = Timer.new()
	timer.name = "Timer"
	timer.set_wait_time(time)
	timer.set_one_shot(true)
	add_child(timer)
	timer.connect("timeout", self, "on_timer_runout")
	$hud/timer/container/time_text.set_text("%2.2f" % time)

func _process(delta):
	if has_node("Timer"):
		if not get_tree().is_paused():
			$hud/timer/container/time_text.set_text("%2.2f" % $Timer.get_time_left())

func on_timer_runout():
	$hud/timer/container/time_text.set_text("%2.2f" % 0)
	$hud/background/reset_buttons/reset.set_disabled(false)
	emit_signal("play_sound", "aww")
	$hud/time_message.set_visible(true)

func play_sound(sound_name):
	emit_signal("play_sound", sound_name)
