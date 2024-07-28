class_name LevelManager
extends StateMachine

func _enter_tree() -> void:
    Helpers.safe_connect(EventBus.performed_actions, on_performed_actions)

func on_performed_actions() -> void:
    var unit_nodes: Array[Node] = get_tree().get_nodes_in_group("units")
    var green_count: int = 0
    var red_count: int = 0

    for unit_node: Node in unit_nodes:
        var unit: Unit = unit_node as Unit

        if unit.faction == Enums.Faction.Green:
            green_count += 1

        if unit.faction == Enums.Faction.Red:
            red_count += 1

    if green_count == 0:
        EventBus.game_victory.emit(Enums.Faction.Red)
    elif red_count == 0:
        EventBus.game_victory.emit(Enums.Faction.Green)