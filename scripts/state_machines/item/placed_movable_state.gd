class_name PlacedMovableState
extends IdleState

@export var placed_immovable_state: PlacedImmovableState

func enter(parent: Node) -> void:
    super.enter(parent)
    Helpers.safe_connect(EventBus.player_turn_end, on_player_turn_end)

func exit(parent: Node) -> void:
    Helpers.safe_disconnect(EventBus.player_turn_end, on_player_turn_end)
    super.exit(parent)

func on_player_turn_end() -> void:
    transitioned.emit(placed_immovable_state)

func is_placed_in_world() -> bool:
    return true
