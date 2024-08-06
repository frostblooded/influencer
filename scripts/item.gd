class_name Item
extends PlaceableObject

@export var state_machine: StateMachine

func on_world_turn() -> void:
    pass

func can_be_moved() -> bool:
    var item_state: ItemState = state_machine.current_state as ItemState
    return item_state.can_be_moved()

func is_placed_in_world() -> bool:
    var item_state: ItemState = state_machine.current_state as ItemState
    return item_state.is_placed_in_world()
