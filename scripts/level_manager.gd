class_name LevelManager
extends StateMachine

var turn: int = 0

func _enter_tree() -> void:
    Helpers.safe_connect(EventBus.on_update_unit_moves, update_unit_moves)

func update_unit_moves() -> void:
    for unit_node: Node in get_tree().get_nodes_in_group("units"):
        var unit: Unit = unit_node as Unit
        unit.update_actions()
