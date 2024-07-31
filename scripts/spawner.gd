class_name Spawner
extends Resource

@export var grid_coordinates: Vector2
@export var faction: Faction
@export var unit_scene: PackedScene

func spawn() -> Unit:
    var unit: Unit = unit_scene.instantiate() as Unit
    unit.faction = faction
    return unit
