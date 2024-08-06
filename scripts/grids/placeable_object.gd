class_name PlaceableObject
extends Node2D

var cell: GridCell

func on_spawned_in_world() -> void:
    pass

func destroy() -> void:
    queue_free()
    cell.empty_container()

func _to_string() -> String:
    return str(get_instance_id())
