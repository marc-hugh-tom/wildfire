extends Node2D

onready var tilemap = $TileMap_below
onready var tileset = tilemap.tile_set

#const CAMPFIRE = preload("res://nodes/campfire.tscn")
#const TREE = preload("res://nodes/tree.tscn")
#const DRYTREES = preload("res://nodes/dry_trees.tscn")
#const TREEHOUSE = preload("res://nodes/treehouse.tscn")
#const ICE_BLOCK = preload("res://nodes/ice_block.tscn")

const CAMPFIRE = preload("res://nodes/burnable/campfire.tscn")
const TREE = preload("res://nodes/burnable/tree.tscn")

var scenes_by_tile_name = {
	"campfire": CAMPFIRE,
	"tree": TREE,
#	"dry_trees": DRYTREES,
#	"treehouse": TREEHOUSE
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
#			instance.init(coord, self, "get_neighbours")
#			instance.connect('update_position', self, "_on_entity_position")
			add_child(instance)
			instance.set_position(tilemap.map_to_world(coord))

func _on_entity_position(instance, new_position):
	# figure out index from new_position
	var index = 0
	grid[index] = [instance]

func coord_to_index(rect, coord):
	var offset = rect.position
	coord -= offset
	return coord.x + (rect.size.x * coord.y)

func get_neighbours(entity):
	var neighbours = [
		[-1, 0],
		[0, 1],
		[1, 0],
		[0, -1],
		[-1, -1],
		[1, 1],
		[1, -1],
		[-1, 1]
	]
	var ret = []
	for neightbour in neighbours:
		var rect = tilemap.get_used_rect()
		var neighbour_coord = Vector2(
			entity.pos.x + neightbour[0], entity.pos.y + neightbour[1]
		)
		if neighbour_coord.x >= rect.position.x && neighbour_coord.x < rect.end.x && \
			neighbour_coord.y >= rect.position.y && neighbour_coord.y < rect.end.y:
			var index = coord_to_index(rect, neighbour_coord)
			assert(grid[index] != entity)
			if grid[index] != null:
				ret.push_front(grid[index])
	return ret
