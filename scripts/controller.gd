extends Node2D

signal treehouse_burnt

onready var tilemap = $TileMap
onready var tileset = tilemap.tile_set

const CAMPFIRE = preload("res://nodes/campfire.tscn")
const TREE = preload("res://nodes/tree.tscn")
const DRY_TREE = preload("res://nodes/dry_trees.tscn")
const TREEHOUSE = preload("res://nodes/treehouse.tscn")

const PLANT_KILLER = preload("res://nodes/plantkiller.tscn")

var scenes_by_tile_name = {
	"campfire": CAMPFIRE,
	"tree": TREE,
	"dry_trees": DRY_TREE,
	"treehouse": TREEHOUSE,
}

var items = {
	"Plant Killer": PLANT_KILLER
}

var grid = []

func _ready():
	tilemap.set_visible(false)
	init_entities()

func init_entities():
	var rect = tilemap.get_used_rect()
	grid.resize(rect.get_area())

	for coord in tilemap.get_used_cells():
		var index = coord_to_index(rect, coord)
		var cell_id = tilemap.get_cell(coord.x, coord.y)
		var tile_name = tileset.tile_get_name(cell_id)

		var scene = scenes_by_tile_name[tile_name]
		if scene != null:
			var instance = scene.instance()
			add_child(instance)
			instance.set_position(tilemap.map_to_world(coord))

			if tile_name == "treehouse":
				instance.connect("treehouse_burnt", self, "emit_signal", ["treehouse_burnt"])

func coord_to_index(rect, coord):
	var offset = rect.position
	coord -= offset
	return coord.x + (rect.size.x * coord.y)

func plantkiller_validity(world_position):
	for child in get_children():
		if child.has_method("get_placeable_name"):
			if child.get_placeable_name() == "tree":
				if tilemap.world_to_map(child.position) == tilemap.world_to_map(world_position):
					return(true)
	return(false)

func plantkiller_application(world_position):
	for child in get_children():
		if child.has_method("get_placeable_name"):
			if child.get_placeable_name() == "tree":
				if tilemap.world_to_map(child.position) == tilemap.world_to_map(world_position):
					var child_position = child.get_position()
					child.queue_free()
					var dry_tree = DRY_TREE.instance()
					dry_tree.set_position(child_position)
					add_child(dry_tree)
