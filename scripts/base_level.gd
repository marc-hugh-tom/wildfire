extends Node2D

signal treehouse_burnt
signal target_hit
signal play_sound

onready var tilemap = $TileMap
onready var tileset = tilemap.tile_set

const CAMPFIRE = preload("res://nodes/campfire.tscn")
const TREE = preload("res://nodes/tree.tscn")
const DRY_TREE = preload("res://nodes/dry_trees.tscn")
const TREEHOUSE = preload("res://nodes/treehouse.tscn")
const ROCK = preload("res://nodes/rock.tscn")

const PLANT_KILLER = preload("res://nodes/plantkiller.tscn")
const CIGARETTE = preload("res://nodes/cigarette.tscn")
const PETROL_CAN = preload("res://nodes/petrol.tscn")

const ICE_BLOCK = preload("res://nodes/ice_block.tscn")
const FIREWORK = preload("res://nodes/firework.tscn")
const TARGET = preload("res://nodes/target.tscn")

var scenes_by_tile_name = {
	"campfire": CAMPFIRE,
	"tree": TREE,
	"dry_trees": DRY_TREE,
	"treehouse": TREEHOUSE,
	"icecube": ICE_BLOCK,
	"rock": ROCK,
	"petrol": PETROL_CAN,
	"cigarette": CIGARETTE,
	"firework": FIREWORK,
	"target": TARGET,
}

var all_items = {
	"Plant Killer": PLANT_KILLER,
	"Cigarette": CIGARETTE,
	"Petrol Can": PETROL_CAN,
	"Ice Cube": ICE_BLOCK,
	"Firework": FIREWORK,
}

func init_items():
	var ret = {}
	var available_items = get_available_items()
	for item in all_items.keys():
		if available_items.has(item):
			ret[item] = all_items[item]
	return ret

func get_start_money():
	assert(false)

func get_available_items():
	assert(false)

func get_start_time_seconds():
	assert(false)

func get_next_level():
	assert(false)

func get_tutorial_text():
	return("")

func get_music_path():
	return ""

func _ready():
	tilemap.set_visible(false)
	init_non_tile_entities()
	init_entities()

func init_non_tile_entities():
	for child in get_children():
		if child.has_node("Rotatable"):
			var rotate_node = child.get_node("Rotatable")
			child.remove_child(rotate_node)
			rotate_node.queue_free()
		if child.has_signal("play_sound"):
			child.connect("play_sound", self, "play_sound")

func init_entities():
	var rect = tilemap.get_used_rect()
	for coord in tilemap.get_used_cells():
		var index = coord_to_index(rect, coord)
		var cell_id = tilemap.get_cell(coord.x, coord.y)
		var tile_name = tileset.tile_get_name(cell_id)

		var scene = scenes_by_tile_name[tile_name]
		if scene != null:
			var instance = scene.instance()
			add_child(instance)
			if not instance.has_signal("play_sound"):
				print(instance)
			instance.connect("play_sound", self, "play_sound")
			instance.set_position(tilemap.map_to_world(coord))
			if tile_name == "treehouse":
				instance.connect("treehouse_burnt", self, "emit_signal", ["treehouse_burnt"])

			if tile_name == "target":
				instance.connect("target_hit", self, "emit_signal", ["target_hit"])

func coord_to_index(rect, coord):
	var offset = rect.position
	coord -= offset
	return coord.x + (rect.size.x * coord.y)

func play_sound(sound_name):
	emit_signal("play_sound", sound_name)

func plantkiller_validity(world_position):
	for child in get_children():
		if child.has_method("get_placeable_name"):
			if child.get_placeable_name() == "tree":
				if tilemap.world_to_map(child.position) == tilemap.world_to_map(world_position):
					return(true)
	return(false)

func plantkiller_application(world_position, item_rotation):
	for child in get_children():
		if child.has_method("get_placeable_name"):
			if child.get_placeable_name() == "tree":
				if tilemap.world_to_map(child.position) == tilemap.world_to_map(world_position):
					var child_position = child.get_position()
					child.queue_free()
					var dry_tree = DRY_TREE.instance()
					dry_tree.connect("play_sound", self, "play_sound")
					dry_tree.set_position(child_position)
					add_child(dry_tree)

func cigarette_validity(world_position):
	for child in get_children():
		if child.has_method("get_placeable_name"):
			if tilemap.world_to_map(child.position) == tilemap.world_to_map(world_position):
				return(false)
	return(true)

func cigarette_application(world_position, item_rotation):
	var cigarette = CIGARETTE.instance()
	cigarette.connect("play_sound", self, "play_sound")
	cigarette.set_rotation(item_rotation)
	cigarette.set_position(tilemap.map_to_world(tilemap.world_to_map(world_position)) + Vector2(16,16))
	var rotatable_node = cigarette.get_node("Rotatable")
	cigarette.remove_child(rotatable_node)
	rotatable_node.queue_free()
	add_child(cigarette)

func petrol_validity(world_position):
	for child in get_children():
		if child.has_method("get_placeable_name"):
			if tilemap.world_to_map(child.position) == tilemap.world_to_map(world_position):
				return(false)
	return(true)

func petrol_application(world_position, item_rotation):
	var petrol = PETROL_CAN.instance()
	petrol.connect("play_sound", self, "play_sound")
	petrol.set_position(tilemap.map_to_world(tilemap.world_to_map(world_position)))
	add_child(petrol)

func ice_block_validity(world_position):
	for child in get_children():
		if child.has_method("get_placeable_name"):
			if tilemap.world_to_map(child.position) == tilemap.world_to_map(world_position):
				return(false)
	return(true)

func ice_block_application(world_position, item_rotation):
	var ice = ICE_BLOCK.instance()
	ice.connect("play_sound", self, "play_sound")
	ice.set_position(tilemap.map_to_world(tilemap.world_to_map(world_position)))
	add_child(ice)

func firework_validity(world_position):
	for child in get_children():
		if child.has_method("get_placeable_name"):
			if tilemap.world_to_map(child.position) == tilemap.world_to_map(world_position):
				return(false)
	return(true)

func firework_application(world_position, item_rotation):
	var firework = FIREWORK.instance()
	firework.set_rotation(item_rotation)
	firework.set_position(tilemap.map_to_world(tilemap.world_to_map(world_position))+Vector2(16,16))
	var rotatable_node = firework.get_node("Rotatable")
	firework.remove_child(rotatable_node)
	rotatable_node.queue_free()
	firework.connect("play_sound", self, "play_sound")
	add_child(firework)

