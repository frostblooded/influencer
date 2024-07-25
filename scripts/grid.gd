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
				var top_cell_neighbor: Cell.Neighbor = Cell.Neighbor.new()
				top_cell_neighbor.cell = top_neighbor
				top_cell_neighbor.direction = Enums.Direction.Top
				cell_instance.neighbors.push_back(top_cell_neighbor)

				var tops_bottom_neighbor: Cell.Neighbor = Cell.Neighbor.new()
				tops_bottom_neighbor.cell = cell_instance
				tops_bottom_neighbor.direction = Enums.Direction.Bottom
				top_neighbor.neighbors.push_back(tops_bottom_neighbor)

			var left_neighbor: Cell = _cells_cache[row_idx][col_idx - 1]
			if left_neighbor:
				var left_cell_neighbor: Cell.Neighbor = Cell.Neighbor.new()
				left_cell_neighbor.cell = left_neighbor
				left_cell_neighbor.direction = Enums.Direction.Left
				cell_instance.neighbors.push_back(left_cell_neighbor)

				var left_right_neightbor: Cell.Neighbor = Cell.Neighbor.new()
				left_right_neightbor.cell = cell_instance
				left_right_neightbor.direction = Enums.Direction.Right
				left_neighbor.neighbors.push_back(left_right_neightbor)
			
			cell_instance.position = Vector2(col_idx * cell_x_diff, row_idx * cell_y_diff)
			cell_instance.grid = self
			cell_instance.grid_coordinates = Vector2(col_idx, row_idx)
			add_child(cell_instance)
	
	for spawner: Spawner in spawners:
		var cell: Cell = _cells_cache[spawner.y][spawner.x]
		assert(cell)

		var unit: Node = spawner.unit_scene.instantiate()
		cell.add_to_container(unit)
