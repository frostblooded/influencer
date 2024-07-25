class_name Unit
extends PlaceableObject

enum Action {
    None,
    Move
}

class GridEnemy:
    var unit: Unit
    var path: Array[Cell] = []
    var direction: Enums.Direction = Enums.Direction.None

    var distance: int:
        get:
            return path.size()

    func _init(new_unit: Unit, new_path: Array[Cell], new_direction: Enums.Direction) -> void:
        unit = new_unit
        path = new_path
        direction = new_direction

var planned_action: Action = Action.None
var planned_move_target: Cell
var planned_action_direction: Enums.Direction = Enums.Direction.None

var _grid_enemies_cache: Array[GridEnemy] = []

func update_actions() -> void:
    planned_action = Action.None
    planned_move_target = null
    planned_action_direction = Enums.Direction.None

    update_grid_enemies()

    if can_move_towards_enemy():
        move_towards_enemy()
    
    print("Updated planned action for ", self, " is ", Action.find_key(planned_action))
    print("Updated planned move target for ", self, " is ", planned_move_target)
    print("Updated planned action direction for ", self, " is ", Enums.Direction.find_key(planned_action_direction))

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
        planned_action_direction = closest_grid_enemy.direction

class PathSearchStatus:
    var cell: Cell
    var path: Array[Cell] = []
    var direction: Enums.Direction = Enums.Direction.None

    func _init(new_cell: Cell, new_path: Array[Cell], new_first_direction: Enums.Direction) -> void:
        cell = new_cell
        path = new_path
        direction = new_first_direction

func update_grid_enemies() -> void:
    _grid_enemies_cache.clear()

    var queue: Array[PathSearchStatus] = []
    queue.push_back(PathSearchStatus.new(cell, [], Enums.Direction.None))

    var visited: Array[Cell] = []

    while !queue.is_empty():
        var current_path_search_status: PathSearchStatus = queue.pop_front()
        var current_cell: Cell = current_path_search_status.cell

        if visited.has(current_cell):
            continue

        visited.push_back(current_cell)
        var current_path: Array[Cell] = current_path_search_status.path
        var current_direction: Enums.Direction = current_path_search_status.direction

        var unit: Unit = current_cell.peek_container() as Unit
        if unit and unit != self:
            _grid_enemies_cache.push_back(GridEnemy.new(unit, current_path, current_direction))
        
        for neighbor: Cell.Neighbor in current_cell.neighbors:
            var path: Array[Cell] = current_path.duplicate()
            path.append(neighbor.cell)

            var direction: Enums.Direction = current_direction
            if direction == Enums.Direction.None:
                direction = neighbor.direction

            queue.push_back(PathSearchStatus.new(neighbor.cell, path, direction))
