class_name Unit
extends PlaceableObject

@export var faction_sprite_2d: Sprite2D
@export var action_sprite_2d: Sprite2D

@export var move_action_texture: Texture2D
@export var move_duration: float = 0.5

class Enemy:
    var unit: Unit
    var path: Array[GridCell] = []

    var distance: int:
        get:
            return path.size()

    func _init(new_unit: Unit, new_path: Array[GridCell]) -> void:
        unit = new_unit
        path = new_path

var faction: Faction:
    set(new_faction):
        faction = new_faction
        faction_sprite_2d.texture = Helpers.create_1_color_gradient_texture(new_faction.color)

var _enemies: Array[Enemy] = []

var _planned_move_direction: Enums.Direction = Enums.Direction.None

func update_plan() -> void:
    update_enemies()
    plan_move()
    update_action_sprite_2d()

func plan_move() -> void:
    if _enemies.is_empty():
        return

    var closest_enemy: Enemy

    for enemy: Enemy in _enemies:
        if !closest_enemy or enemy.distance < closest_enemy.distance:
            closest_enemy = enemy

    if closest_enemy:
        assert(!closest_enemy.path.is_empty())
        _planned_move_direction = cell.get_direction_from_neighbor_cell(closest_enemy.path[0])

func update_action_sprite_2d() -> void:
    if _planned_move_direction != Enums.Direction.None:
        action_sprite_2d.show()
        action_sprite_2d.texture = move_action_texture
        action_sprite_2d.rotation = Enums.direction_to_angle(_planned_move_direction)
    else:
        action_sprite_2d.hide()

class PathSearchStatus:
    var cell: GridCell
    var path: Array[GridCell] = []

    func _init(new_cell: GridCell, new_path: Array[GridCell]) -> void:
        cell = new_cell
        path = new_path

func update_enemies() -> void:
    _enemies.clear()

    var queue: Array[PathSearchStatus] = []
    queue.push_back(PathSearchStatus.new(cell, []))

    var visited: Array[GridCell] = []

    while !queue.is_empty():
        var current_path_search_status: PathSearchStatus = queue.pop_front()
        var current_cell: GridCell = current_path_search_status.cell

        if visited.has(current_cell):
            continue

        visited.push_back(current_cell)
        var current_path: Array[GridCell] = current_path_search_status.path

        var placeable_object: PlaceableObject = current_cell.peek_container()
        var unit: Unit = placeable_object as Unit
        if unit:
            if unit != self:
                _enemies.push_back(Enemy.new(unit, current_path))
        elif placeable_object != null:
            continue
        
        for neighbor: GridCell.Neighbor in current_cell.neighbors:
            var path: Array[GridCell] = current_path.duplicate()
            path.append(neighbor.cell)
            queue.push_back(PathSearchStatus.new(neighbor.cell, path))

func perform_move() -> void:
    var planned_move_target: GridCell = cell.get_neighbor_cell_from_direction(_planned_move_direction)
    var other_cell_containee: PlaceableObject = planned_move_target.peek_container()

    if other_cell_containee:
        var other_cell_unit: Unit = other_cell_containee as Unit
        if other_cell_unit:
            other_cell_unit.destroy()
        else:
            var other_cell_item: Item = other_cell_containee as Item
            if other_cell_item:
                return

    var tween: Tween = create_tween()
    await tween.tween_property(self, "global_position", planned_move_target.global_position, move_duration).finished

    position = Vector2.ZERO
    cell.move_containee_to(planned_move_target)
    reset_planning()

func reset_planning() -> void:
    action_sprite_2d.hide()
    _planned_move_direction = Enums.Direction.None
