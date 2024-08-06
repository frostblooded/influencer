class_name PlaceableObject
extends Node2D

var cell: GridCell

func destroy() -> void:
    queue_free()
    cell.empty_container()

func _to_string() -> String:
    return str(get_instance_id())
