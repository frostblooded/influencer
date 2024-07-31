class_name AITurnState
extends State

@export var faction: Faction
@export var next_state: State

func state_process(_delta: float, _parent: Node) -> void:
    if !is_inside_tree():
        return

    for unit_node: Node in get_tree().get_nodes_in_group("units"):
        var unit: Unit = unit_node as Unit

        if unit.faction == faction:
            unit.perform_action()

    EventBus.performed_actions.emit()
    transitioned.emit(next_state)
