class_name PistonItem
extends Item

@export var area_2d: Area2D
@export var sprite_2d: Sprite2D
@export var move_duration: float = 0.3

var _direction: Enums.Direction = Enums.Direction.Right

func _ready() -> void:
    Helpers.safe_connect(area_2d.input_event, handle_mouse_event)

func on_world_turn() -> void:
    var source_cell: GridCell = cell.get_neighbor_cell_from_direction(_direction)
    if !source_cell:
        return

    var source_cell_object: PlaceableObject = source_cell.peek_container()
    if !source_cell_object:
        return
    
    var target_cell: GridCell = source_cell.get_neighbor_cell_from_direction(_direction)

    if !target_cell:
        await destroy_object(source_cell_object)
        return

    var target_cell_object: PlaceableObject = target_cell.peek_container()

    if target_cell_object:
        return

    var tween: Tween = create_tween()
    await tween.tween_property(source_cell_object, "global_position", target_cell.global_position, move_duration).finished

    source_cell.move_containee_to(target_cell)

func destroy_object(object: PlaceableObject) -> void:
    var promise: Promise = Promise.new()
    object.play_destroy_animation(_direction, promise)
    await promise.async_awaiter()

    object.destroy()

func handle_mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
    if !event is InputEventMouseButton:
        return

    var mouse_button_event: InputEventMouseButton = event as InputEventMouseButton
    if !mouse_button_event.is_pressed():
        return

    if mouse_button_event.button_index != MOUSE_BUTTON_RIGHT:
        return

    if !can_be_moved():
        return

    change_direction_clockwise()

func change_direction_clockwise() -> void:
    _direction = Enums.get_next_clockwise_direction(_direction)
    sprite_2d.rotation = Enums.direction_to_angle(_direction)
