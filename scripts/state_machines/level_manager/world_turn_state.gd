class_name WorldTurnState
extends State

@export var faction: Faction
@export var next_state: State
@export var seconds_between_moves: float = 1

func enter(_parent: Node) -> void:
    EventBus.start_turn.emit(faction)
    await get_tree().create_timer(seconds_between_moves).timeout
    trigger_items()

func trigger_items() -> void:
    if !is_inside_tree():
        return
    
    for item_node: Node in get_tree().get_nodes_in_group("items"):
        var item: Item = item_node as Item

        if item.is_placed_in_world():
            item.on_world_turn()

    EventBus.performed_actions.emit()
    transitioned.emit(next_state)
