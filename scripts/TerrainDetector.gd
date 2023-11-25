class_name TerrainDetector
extends Area2D

signal in_normal
signal in_swarm
signal in_wire

enum TerrainType {
	NO_TERRAIN = -1,
	NORMAL = 0,
	SWARM = 1,
	WIRE = 2
}

var current_tilemap: TileMap
var current_terrain: TerrainType
var previous_terrain: TerrainType

func _exit_tree() -> void:
	current_tilemap = null
	current_terrain = TerrainType.NO_TERRAIN


func _update_terrain(terrain_mask: TerrainType) -> void:
	if terrain_mask != current_terrain:
		previous_terrain = current_terrain
		current_terrain = terrain_mask
		if current_terrain == TerrainType.NORMAL:
			emit_signal("in_normal")
		elif current_terrain == TerrainType.SWARM:
			emit_signal("in_swarm")
		elif current_terrain == TerrainType.WIRE:
			emit_signal("in_wire")
		else:
			assert(false, "not a normal tile")

func _process_terrain(body_rid: RID, body: TileMap) -> void:
	current_tilemap = body
	var collided_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
	for index in current_tilemap.get_layers_count():
		var tile_data: TileData = current_tilemap.get_cell_tile_data(index, collided_tile_coords)
		if tile_data:
			var terrain_mask = tile_data.get_custom_data("obstacles")
			_update_terrain(terrain_mask) 

func _on_body_shape_entered(body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is TileMap:
		_process_terrain(body_rid, body)
