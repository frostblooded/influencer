class_name RedTurnState
extends State

func enter(_parent: Node) -> void:
    print("Enter red state")

func state_process(_delta: float, _parent: Node) -> void:
    if !is_inside_tree():
        return

    for unit_node: Node in get_tree().get_nodes_in_group("units"):
        var unit: Unit = unit_node as Unit

        if unit.faction == Enums.Faction.Red:
            unit.perform_action()

    EventBus.performed_actions.emit()
    transitioned.emit(self, "PlayerTurnState")

func exit(_parent: Node) -> void:
    print("Exit red state")
