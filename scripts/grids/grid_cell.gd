class_name GridCell
extends Cell

class Neighbor:
    var cell: GridCell
    var direction: Enums.Direction = Enums.Direction.None

    func _init(new_cell: Cell, new_direction: Enums.Direction) -> void:
        cell = new_cell
        direction = new_direction

var neighbors: Array[Neighbor]

var grid: Grid
var grid_coordinates: Vector2

func get_neighbor_cell_from_direction(direction: Enums.Direction) -> GridCell:
    for neighbor: Neighbor in neighbors:
        if neighbor.direction == direction:
            return neighbor.cell
    
    return null

func get_direction_from_neighbor_cell(neighbor_cell: GridCell) -> Enums.Direction:
    for neighbor: Neighbor in neighbors:
        if neighbor.cell == neighbor_cell:
            return neighbor.direction
    
    return Enums.Direction.None

func _to_string() -> String:
    return "({}, {})({})".format([grid_coordinates.x, grid_coordinates.y, get_instance_id()], "{}")
