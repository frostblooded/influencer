extends Node

var reputations: Dictionary = {}

func _ready() -> void:
    Helpers.safe_connect(EventBus.level_victory, _on_win)
    EventBus.level_start.connect(_on_level_start)

func _on_level_start() -> void:
    for faction: Faction in reputations.keys():
        EventBus.reputation_change.emit(faction, reputations[faction])

func _on_win(faction: Faction) -> void:
    reputations[faction] += 10
    EventBus.reputation_change.emit(faction, reputations[faction])

func register_faction(faction: Faction) -> void:
    if reputations.has(faction):
        return

    reputations[faction] = 0
    EventBus.reputation_change.emit(faction, 0)
