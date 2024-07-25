class_name PlaceableObject
extends Node2D

var cell: GridCell

func _to_string() -> String:
    return "{}".format([cell], "{}")
