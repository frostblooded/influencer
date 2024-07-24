class_name PlayerTurnState
extends State

func enter(_parent: Node) -> void:
    EventBus.on_update_unit_moves.emit()
