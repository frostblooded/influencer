extends Button

func _enter_tree() -> void:
    Helpers.safe_connect(pressed, end_turn_button_pressed)

func end_turn_button_pressed() -> void:
    EventBus.on_end_turn_button_pressed.emit()
