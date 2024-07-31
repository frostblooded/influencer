class_name LevelManager
extends Node

@export var factions: Array[Faction]

func _enter_tree() -> void:
    Helpers.safe_connect(EventBus.performed_actions, on_performed_actions)

func on_performed_actions() -> void:
    var unit_nodes: Array[Node] = get_tree().get_nodes_in_group("units")
    var factions_alive: Dictionary = {}
    
    for faction: Faction in factions:
        factions_alive[faction] = false

    for unit_node: Node in unit_nodes:
        var unit: Unit = unit_node as Unit
        factions_alive[unit.faction] = true

    var is_any_faction_dead: bool = factions_alive.values().any(
        func(alive: bool) -> bool:
            return !alive)

    if !is_any_faction_dead:
        return

    for faction: Faction in factions:
        if factions_alive[faction]:
            EventBus.level_victory.emit(faction)
            return