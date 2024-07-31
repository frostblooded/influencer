class_name Unit
extends PlaceableObject

@export var move_action_texture: Texture2D
@export var faction_sprite_2d: Sprite2D

var faction: Faction:
    set(new_faction):
        faction = new_faction
        faction_sprite_2d.texture = Helpers.create_1_color_gradient_texture(new_faction.color)

enum Action {
    None,
    Move
}

class GridEnemy:
    var unit: Unit
    var path: Array[GridCell] = []
    var direction: Enums.Direction = Enums.Direction.None

    var distance: int:
        get:
            return path.size()

    func _init(new_unit: Unit, new_path: Array[GridCell], new_direction: Enums.Direction) -> void:
        unit = new_unit
        path = new_path
        direction = new_direction

var planned_action: Action = Action.None
var planned_action_direction: Enums.Direction = Enums.Direction.None

var _grid_enemies_cache: Array[GridEnemy] = []

func update_actions() -> void:
    planned_action = Action.None
    planned_action_direction = Enums.Direction.None

    update_grid_enemies()

    if can_plan_move_towards_enemy():
        plan_move_towards_enemy()
    
    if planned_action != Action.None:
        cell.set_action_sprite_2d(move_action_texture, planned_action_direction)

func can_plan_move_towards_enemy() -> bool:
    return !_grid_enemies_cache.is_empty()

func plan_move_towards_enemy() -> void:
    var closest_grid_enemy: GridEnemy

    for grid_enemy: GridEnemy in _grid_enemies_cache:
        if !closest_grid_enemy or grid_enemy.distance < closest_grid_enemy.distance:
            closest_grid_enemy = grid_enemy

    if closest_grid_enemy:
        planned_action = Action.Move
        planned_action_direction = closest_grid_enemy.direction

class PathSearchStatus:
    var cell: GridCell
    var path: Array[GridCell] = []
    var direction: Enums.Direction = Enums.Direction.None

    func _init(new_cell: GridCell, new_path: Array[GridCell], new_first_direction: Enums.Direction) -> void:
        cell = new_cell
        path = new_path
        direction = new_first_direction

func update_grid_enemies() -> void:
    _grid_enemies_cache.clear()

    var queue: Array[PathSearchStatus] = []
    queue.push_back(PathSearchStatus.new(cell, [], Enums.Direction.None))

    var visited: Array[GridCell] = []

    while !queue.is_empty():
        var current_path_search_status: PathSearchStatus = queue.pop_front()
        var current_cell: GridCell = current_path_search_status.cell

        if visited.has(current_cell):
            continue

        visited.push_back(current_cell)
        var current_path: Array[GridCell] = current_path_search_status.path
        var current_direction: Enums.Direction = current_path_search_status.direction

        var placeable_object: PlaceableObject = current_cell.peek_container()
        var unit: Unit = placeable_object as Unit
        if unit:
            if unit != self:
                _grid_enemies_cache.push_back(GridEnemy.new(unit, current_path, current_direction))
        elif placeable_object != null:
            continue
        
        for neighbor: GridCell.Neighbor in current_cell.neighbors:
            var path: Array[GridCell] = current_path.duplicate()
            path.append(neighbor.cell)

            var direction: Enums.Direction = current_direction
            if direction == Enums.Direction.None:
                direction = neighbor.direction

            queue.push_back(PathSearchStatus.new(neighbor.cell, path, direction))

func perform_action() -> void:
    match planned_action:
        Action.Move:
            perform_move()

func perform_move() -> void:
    var other_cell: GridCell = cell.get_neighbor_cell_from_direction(planned_action_direction) as GridCell

    var other_cell_containee: PlaceableObject = other_cell.peek_container()

    if other_cell_containee != null:
        var other_cell_unit: Unit = other_cell_containee as Unit
        if other_cell_unit != null:
            other_cell_unit.queue_free()
        else:
            var other_cell_element: ElementPlaceableObject = other_cell_containee as ElementPlaceableObject
            if other_cell_element:
                if other_cell_element.is_blocking:
                    return
                
                if other_cell_element.is_damaging:
                    cell.reset_action_sprite_2d()
                    cell.empty_container()
                    return

        other_cell.reset_action_sprite_2d()
        other_cell.empty_container()

    cell.reset_action_sprite_2d()
    cell.empty_container()
    other_cell.add_to_container(self)
