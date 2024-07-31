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
	Helpers.safe_array_resize_2d(_cells_cache, height, width)

	for y: int in range(0, height):
		for x: int in range(0, width):
			var cell_instance: GridCell = cell_scene.instantiate() as GridCell
			_cells_cache[y][x] = cell_instance

			var top_neighbor: GridCell = _cells_cache[y - 1][x]
			if top_neighbor:
				cell_instance.neighbors.push_back(GridCell.Neighbor.new(top_neighbor, Enums.Direction.Top))
				top_neighbor.neighbors.push_back(GridCell.Neighbor.new(cell_instance, Enums.Direction.Bottom))

			var left_neighbor: GridCell = _cells_cache[y][x - 1]
			if left_neighbor:
				cell_instance.neighbors.push_back(GridCell.Neighbor.new(left_neighbor, Enums.Direction.Left))
				left_neighbor.neighbors.push_back(GridCell.Neighbor.new(cell_instance, Enums.Direction.Right))
			
			cell_instance.position = Vector2(x * cell_x_diff, y * cell_y_diff)
			cell_instance.grid = self
			cell_instance.grid_coordinates = Vector2(x, y)
			add_child(cell_instance)
	
	for spawner: Spawner in spawners:
		var cell: GridCell = _cells_cache[spawner.grid_coordinates.y][spawner.grid_coordinates.x]
		assert(cell)
		cell.add_to_container(spawner.spawn())
