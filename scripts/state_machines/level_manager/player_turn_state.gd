class_name PlayerTurnState
extends State

@export var next_state: State

func enter(_parent: Node) -> void:
    Helpers.safe_connect(EventBus.on_end_turn_button_pressed, on_end_turn_button_pressed)

    for unit_node: Node in get_tree().get_nodes_in_group("units"):
        var unit: Unit = unit_node as Unit
        unit.update_actions()
    
func exit(_parent: Node) -> void:
    Helpers.safe_disconnect(EventBus.on_end_turn_button_pressed, on_end_turn_button_pressed)

func on_end_turn_button_pressed() -> void:
    transitioned.emit(next_state)
