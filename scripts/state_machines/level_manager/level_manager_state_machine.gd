class_name LevelManagerStateMachine
extends StateMachine

func _enter_tree() -> void:
    Helpers.safe_connect(EventBus.level_victory, on_level_victory)

func on_level_victory(_faction: Faction) -> void:
    disabled = true
