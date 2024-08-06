class_name UnitSpawner
extends Spawner

@export var faction: Faction

func spawn() -> Unit:
    var unit: Unit = scene.instantiate() as Unit
    unit.faction = faction
    return unit
