class_name Cell
extends Node2D

@export var area_2d: Area2D
@export var default_sprite_2d: Sprite2D
@export var hovered_sprite_2d: Sprite2D
@export var debug_sprite_2d: Sprite2D

@export var _container: Node2D

var top_cell: Cell
var right_cell: Cell
var bottom_cell: Cell
var left_cell: Cell

var grid: Grid
var grid_x: int = -1
var grid_y: int = -1

func _ready() -> void:
	Helpers.safe_connect(area_2d.mouse_entered, on_mouse_entered)
	Helpers.safe_connect(area_2d.mouse_exited, on_mouse_exited)

	default_sprite_2d.show()
	hovered_sprite_2d.hide()
	debug_sprite_2d.hide()

func on_mouse_entered() -> void:
	default_sprite_2d.hide()
	hovered_sprite_2d.show()

func on_mouse_exited() -> void:
	default_sprite_2d.show()
	hovered_sprite_2d.hide()

func add_to_container(node: Node) -> void:
	assert(_container.get_child_count() == 0)

	var placeable_object: PlaceableObject = node as PlaceableObject
	placeable_object.cell = self
	_container.add_child(placeable_object)

func peek_container() -> PlaceableObject:
	assert(_container.get_child_count() <= 1)

	if _container.get_child_count() == 1:
		return _container.get_child(0)
	else:
		return null

func show_debug() -> void:
	debug_sprite_2d.show()

func hide_debug() -> void:
	debug_sprite_2d.hide()

func _to_string() -> String:
	return "({}, {})".format([grid_y, grid_x], "{}")
