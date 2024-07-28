class_name DraggedState
extends State

@export var area_2d: Area2D
var _initial_position: Vector2

func enter(parent: Node) -> void:
	var parent_2d: Node2D = parent as Node2D
	_initial_position = parent_2d.global_position

func state_process(_delta: float, parent: Node) -> void:
	var parent_2d: Node2D = parent as Node2D
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	parent_2d.global_position = mouse_position

	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		handle_mouse_release(parent_2d)

func handle_mouse_release(parent: Node2D) -> void:
	for overlapping_area: Area2D in area_2d.get_overlapping_areas():
		var area_parent: Node = overlapping_area.get_parent()
		if area_parent is GridCell:
			var cell: GridCell = area_parent as GridCell
			Helpers.orphan(parent)
			cell.empty_container()
			cell.add_to_container(parent)
			parent.position = Vector2.ZERO
			transitioned.emit(self, "ImmovableState")
			return

	parent.global_position = _initial_position
	transitioned.emit(self, "IdleState")
