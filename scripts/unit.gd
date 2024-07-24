class_name Unit
extends PlaceableObject

enum Action {
    None,
    Move
}

class GridEnemy:
    var unit: Unit
    var path: Array[Cell] = []

    var distance: int:
        get:
            return path.size()

    func _init(new_unit: Unit, new_path: Array[Cell]) -> void:
        unit = new_unit
        path = new_path

var planned_action: Action = Action.None
var planned_move_target: Cell

var _grid_enemies_cache: Array[GridEnemy] = []

func update_moves() -> void:
    planned_action = Action.None
    planned_move_target = null

    update_grid_enemies()

    if can_move_towards_enemy():
        move_towards_enemy()
    
    print("Updated planned action for ", self, " is ", Action.find_key(planned_action))
    print("Updated planned move target for ", self, " is ", planned_move_target)

func can_move_towards_enemy() -> bool:
    return !_grid_enemies_cache.is_empty()

func move_towards_enemy() -> void:
    var closest_grid_enemy: GridEnemy

    for grid_enemy: GridEnemy in _grid_enemies_cache:
        if !closest_grid_enemy or grid_enemy.distance < closest_grid_enemy.distance:
            closest_grid_enemy = grid_enemy

    if closest_grid_enemy and closest_grid_enemy.distance > 1:
        assert(!closest_grid_enemy.path.is_empty())
        planned_action = Action.Move
        planned_move_target = closest_grid_enemy.path[0]

class PathSearchStatus:
    var cell: Cell
    var path: Array[Cell] = []

    func _init(new_cell: Cell, new_path: Array[Cell]) -> void:
        cell = new_cell
        path = new_path

func update_grid_enemies() -> void:
    _grid_enemies_cache.clear()

    var queue: Array[PathSearchStatus] = []
    queue.push_back(PathSearchStatus.new(cell, []))

    var visited: Array[Cell] = []

    while !queue.is_empty():
        var current_path_search_status: PathSearchStatus = queue.pop_front()
        var current_cell: Cell = current_path_search_status.cell

        if visited.has(current_cell):
            continue

        visited.push_back(current_cell)
        var current_path: Array[Cell] = current_path_search_status.path

        var unit: Unit = current_cell.peek_container() as Unit
        if unit and unit != self:
            _grid_enemies_cache.push_back(GridEnemy.new(unit, current_path))

        if current_cell.top_cell:
            var top_path: Array[Cell] = current_path.duplicate()
            top_path.append(current_cell.top_cell)
            queue.push_back(PathSearchStatus.new(current_cell.top_cell, top_path))

        if current_cell.right_cell:
            var right_path: Array[Cell] = current_path.duplicate()
            right_path.append(current_cell.right_cell)
            queue.push_back(PathSearchStatus.new(current_cell.right_cell, right_path))

        if current_cell.bottom_cell:
            var bottom_path: Array[Cell] = current_path.duplicate()
            bottom_path.append(current_cell.bottom_cell)
            queue.push_back(PathSearchStatus.new(current_cell.bottom_cell, bottom_path))

        if current_cell.left_cell:
            var left_path: Array[Cell] = current_path.duplicate()
            left_path.append(current_cell.left_cell)
            queue.push_back(PathSearchStatus.new(current_cell.left_cell, left_path))
