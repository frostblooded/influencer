class_name LevelManager
extends StateMachine

func _enter_tree() -> void:
    Helpers.safe_connect(EventBus.on_end_turn_button_pressed, on_end_turn_button_pressed)

func update_unit_moves() -> void:
    for unit_node: Node in get_tree().get_nodes_in_group("units"):
        var unit: Unit = unit_node as Unit
        unit.update_actions()

func on_end_turn_button_pressed() -> void:
    print("End turn")
