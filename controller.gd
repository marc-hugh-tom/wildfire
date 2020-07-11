extends Node2D

onready var tilemap = $TileMap
onready var tileset = $TileMap.tile_set

const CAMPFIRE = preload("res://campfire.tscn")
const TREE = preload("res://tree.tscn")
const TREEHOUSE = preload("res://treehouse.tscn")

var scenes_by_tile_name = {
	"campfire": CAMPFIRE,
	"tree": TREE,
	"treehouse": TREEHOUSE
}

var entities = []

func _ready():
	init_entities()
	
func init_entities():
	var rect = tilemap.get_used_rect()
	entities.resize(rect.get_area())

	for coord in tilemap.get_used_cells():
		var index = coord_to_index(rect, coord)
		var cell_id = tilemap.get_cell(coord.x, coord.y)
		var tile_name = tileset.tile_get_name(cell_id)
		
		var scene = scenes_by_tile_name[tile_name]
		if scene != null:
			var instance = scene.instance()
			instance.init(coord)
			entities[index] = instance
			add_child(instance)
	
	for entity in entities:
		if entity != null:
			for neighbour in get_neighbours(entity):
				assert(entity != neighbour)
				entity.fsm.connect("spread", neighbour.fsm, "_on_fire_spread")

func coord_to_index(rect, coord):
	var offset = rect.position
	coord -= offset
	return coord.x + (rect.size.x * coord.y)

func get_neighbours(entity):
	var neighbours = [
		[-1, 0],
		[0, 1],
		[1, 0],
		[0, -1]
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
			assert(entities[index] != entity)
			if entities[index] != null:
				ret.push_front(entities[index])
	return ret
