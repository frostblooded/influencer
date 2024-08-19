class_name Unit
extends PlaceableObject

@export var faction_sprite_2d: Sprite2D
@export var action_sprite_2d: Sprite2D
@export var animated_sprite_2d: AnimatedSprite2D

@export var move_action_texture: Texture2D
@export var move_duration: float = 0.5
@export var can_move: bool = true

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
    if !can_move:
        return

    update_enemies()
    plan_move()
    update_action_sprite_2d()

func plan_move() -> void:
    if _enemies.is_empty():
        return

    var closest_enemy: Enemy = null

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
                if unit.faction == faction:
                    continue
                else:
                    _enemies.push_back(Enemy.new(unit, current_path))
        elif placeable_object != null:
            continue
        
        for neighbor: GridCell.Neighbor in current_cell.neighbors:
            var path: Array[GridCell] = current_path.duplicate()
            path.append(neighbor.cell)
            queue.push_back(PathSearchStatus.new(neighbor.cell, path))

func perform_move() -> void:
    if !can_move:
        return

    action_sprite_2d.hide()

    var planned_move_target: GridCell = cell.get_neighbor_cell_from_direction(_planned_move_direction)
    if planned_move_target:
        var other_cell_containee: PlaceableObject = planned_move_target.peek_container()

        if other_cell_containee:
            var other_cell_unit: Unit = other_cell_containee as Unit
            if other_cell_unit:
                await play_kill_other_unit_animation(other_cell_unit, _planned_move_direction)
                other_cell_unit.destroy()
                cell.move_containee_to(planned_move_target)
                return
            else:
                var other_cell_item: Item = other_cell_containee as Item
                if other_cell_item:
                    await play_crash_animation(planned_move_target, other_cell_item)
                    return

        var tween: Tween = create_tween()
        tween.tween_property(self, "global_position", planned_move_target.global_position, move_duration) \
            .set_trans(Tween.TRANS_QUAD)
        await tween.finished

        cell.move_containee_to(planned_move_target)

func play_kill_other_unit_animation(unit: Unit, direction: Enums.Direction) -> void:
    var move_vector: Vector2 = unit.global_position - global_position
    var half_move_goal: Vector2 = global_position + move_vector / 2

    var destroy_animation_promise: Promise = Promise.new()

    var tween: Tween = create_tween()
    tween.tween_property(self, "global_position", half_move_goal, move_duration / 4)
    tween.tween_callback(unit.play_destroy_animation.bind(direction, destroy_animation_promise))
    tween.tween_property(self, "global_position", unit.global_position, move_duration / 4)
    await tween.finished
    await destroy_animation_promise.async_awaiter()

func play_crash_animation(unmovable_cell: GridCell, unmovable_cell_item: Item) -> void:
    var initial_position: Vector2 = global_position
    var half_move: Vector2 = (unmovable_cell.global_position - initial_position) / 2
    var half_goal: Vector2 = initial_position + half_move

    var go_tween: Tween = create_tween()
    go_tween.tween_property(self, "global_position", half_goal, move_duration / 2)
    go_tween.tween_callback(animated_sprite_2d.play.bind("crash"))
    await go_tween.finished

    unmovable_cell_item.on_unit_crash(_planned_move_direction)

    var rotation_tween: Tween = create_tween()
    rotation_tween.tween_property(self, "rotation", -0.1, move_duration / 6)
    rotation_tween.tween_property(self, "rotation", + 0.1, move_duration / 3)
    rotation_tween.tween_property(self, "rotation", 0, move_duration / 6)

    var camera_shake_tween: Tween = create_tween()
    var camera: Camera2D = get_viewport().get_camera_2d()
    camera_shake_tween.tween_method(Helpers.play_camera_shake.bind(camera), 5, 1, move_duration * 2 / 3)

    await rotation_tween.finished
    await camera_shake_tween.finished

    var return_tween: Tween = create_tween()
    return_tween.tween_property(self, "global_position", initial_position, move_duration / 2)
    return_tween.tween_callback(animated_sprite_2d.play.bind("default"))
    await return_tween.finished

func play_destroy_animation(direction: Enums.Direction, promise: Promise) -> void:
    faction_sprite_2d.hide()
    super.play_destroy_animation(direction, promise)