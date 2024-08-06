class_name Spawner
extends Resource

@export var grid_coordinates: Vector2
@export var scene: PackedScene

func spawn() -> PlaceableObject:
    if !scene:
        return null

    var placeable_object: PlaceableObject = scene.instantiate()
    placeable_object.on_spawned_in_world()
    return placeable_object
