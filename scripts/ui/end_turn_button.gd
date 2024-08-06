extends Button

@export var player_faction: Faction

func _enter_tree() -> void:
    Helpers.safe_connect(pressed, end_turn_button_pressed)
    Helpers.safe_connect(EventBus.start_turn, on_start_turn)
    Helpers.safe_connect(EventBus.level_victory, on_level_victory)

func end_turn_button_pressed() -> void:
    EventBus.on_end_turn_button_pressed.emit()

func on_start_turn(faction: Faction) -> void:
    disabled = faction != player_faction

func on_level_victory(_faction: Faction) -> void:
    disabled = true
