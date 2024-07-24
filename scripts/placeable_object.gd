class_name PlaceableObject
extends Node2D

var cell: Cell

func _to_string() -> String:
    return "{}".format([cell], "{}")
