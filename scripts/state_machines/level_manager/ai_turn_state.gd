class_name AITurnState
extends State

@export var faction: Faction
@export var next_state: State

@export var seconds_between_moves: float = 1

func enter(_parent: Node) -> void:
    EventBus.start_turn.emit(faction)
    await get_tree().create_timer(seconds_between_moves).timeout
    move_units()

func move_units() -> void:
    if !is_inside_tree():
        return
    
    for unit_node: Node in get_tree().get_nodes_in_group("units"):
        var unit: Unit = unit_node as Unit

        if unit.faction == faction:
            unit.perform_move()

    EventBus.performed_actions.emit()
    transitioned.emit(next_state)
