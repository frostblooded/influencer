class_name Item
extends PlaceableObject

@export var state_machine: StateMachine
@export var placed_immovable_state: PlacedImmovableState

func on_spawned_in_world() -> void:
    state_machine.initial_state = placed_immovable_state

func on_world_turn() -> void:
    await Helpers.empty_coroutine(get_tree())

func can_be_moved() -> bool:
    var item_state: ItemState = state_machine.current_state as ItemState
    return item_state.can_be_moved()

func is_placed_in_world() -> bool:
    var item_state: ItemState = state_machine.current_state as ItemState
    return item_state.is_placed_in_world()

func on_unit_crash(_unit_move_direction: Enums.Direction) -> void:
    pass
