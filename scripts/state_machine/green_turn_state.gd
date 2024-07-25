class_name GreenTurnState
extends State

func enter(_parent: Node) -> void:
    print("Enter green state")

func state_process(_delta: float, _parent: Node) -> void:
    for unit_node: Node in get_tree().get_nodes_in_group("units"):
        var unit: Unit = unit_node as Unit

        if unit.faction == Enums.Faction.Green:
            unit.update_actions()
            unit.perform_action()

    transitioned.emit(self, "RedTurnState")

func exit(_parent: Node) -> void:
    print("Exit green state")
