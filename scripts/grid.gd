class_name Grid
extends Node2D

@export var width: int = 5
@export var height: int = 5
@export var cell_scene: PackedScene
@export var cell_x_diff: int = 112
@export var cell_y_diff: int = 112
@export var spawners: Array[Spawner]

var _cells_cache: Array[Array] = []

func _ready() -> void:
	var resize_height_result: int = _cells_cache.resize(height)
	if resize_height_result != OK:
		push_error(error_string(resize_height_result))
		return

	for row_idx: int in range(0, _cells_cache.size()):
		var resize_width_result: int = _cells_cache[row_idx].resize(width)
		if resize_width_result != OK:
			push_error(error_string(resize_width_result))
			return

	for row_idx: int in range(0, height):
		for col_idx: int in range(0, width):
			var cell_instance: Cell = cell_scene.instantiate() as Cell
			_cells_cache[row_idx][col_idx] = cell_instance

			var top_neighbor: Cell = _cells_cache[row_idx - 1][col_idx]
			if top_neighbor:
				cell_instance.neighbors.push_back(Cell.Neighbor.new(top_neighbor, Enums.Direction.Top))
				top_neighbor.neighbors.push_back(Cell.Neighbor.new(cell_instance, Enums.Direction.Bottom))

			var left_neighbor: Cell = _cells_cache[row_idx][col_idx - 1]
			if left_neighbor:
				cell_instance.neighbors.push_back(Cell.Neighbor.new(left_neighbor, Enums.Direction.Left))
				left_neighbor.neighbors.push_back(Cell.Neighbor.new(cell_instance, Enums.Direction.Right))
			
			cell_instance.position = Vector2(col_idx * cell_x_diff, row_idx * cell_y_diff)
			cell_instance.grid = self
			cell_instance.grid_coordinates = Vector2(col_idx, row_idx)
			add_child(cell_instance)
	
	for spawner: Spawner in spawners:
		var cell: Cell = _cells_cache[spawner.grid_coordinates.y][spawner.grid_coordinates.x]
		assert(cell)

		var unit: Unit = spawner.unit_scene.instantiate() as Unit
		unit.faction = spawner.faction
		cell.add_to_container(unit)
