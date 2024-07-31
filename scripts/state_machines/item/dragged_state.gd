class_name DraggedState
extends State

@export var area_2d: Area2D
@export var immovable_state: State
@export var idle_state: State

var _initial_position: Vector2

func enter(item_node: Node) -> void:
	var item_2d: Node2D = item_node as Node2D
	_initial_position = item_2d.global_position

func state_process(_delta: float, item_node: Node) -> void:
	var item_2d: Node2D = item_node as Node2D
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	item_2d.global_position = mouse_position

	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		handle_mouse_release(item_2d)

func handle_mouse_release(item_node: Node2D) -> void:
	for overlapping_area: Area2D in area_2d.get_overlapping_areas():
		var area_parent: Node = overlapping_area.get_parent()
		if area_parent is GridCell:
			var cell: GridCell = area_parent as GridCell
			Helpers.orphan(item_node)
			cell.empty_container()
			cell.add_to_container(item_node)
			item_node.position = Vector2.ZERO
			transitioned.emit(immovable_state)
			return

	# If we didn't find any usable area, return to initial position
	item_node.global_position = _initial_position
	transitioned.emit(idle_state)
