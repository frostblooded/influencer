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
		handle_mouse_release(item_2d, mouse_position)

func find_best_overlapping_area_for_placing(area: Area2D, mouse_position: Vector2) -> Area2D:
	var best_area: Area2D = null
	var best_distance: float

	for overlapping_area: Area2D in area.get_overlapping_areas():
		var area_parent: Node = overlapping_area.get_parent()
		if area_parent is GridCell:
			var cell: GridCell = area_parent as GridCell

			if cell.peek_container() == null:
				var distance: float = mouse_position.distance_squared_to(cell.global_position)

				if !best_area || distance < best_distance:
					best_area = overlapping_area
					best_distance = distance
	
	return best_area

func handle_mouse_release(item_node: Node2D, mouse_position: Vector2) -> void:
	var best_area: Area2D = find_best_overlapping_area_for_placing(area_2d, mouse_position)
	if !best_area:
		item_node.global_position = _initial_position
		transitioned.emit(idle_state)
		return

	var cell: GridCell = best_area.get_parent() as GridCell
	Helpers.orphan(item_node)
	cell.add_to_container(item_node)
	item_node.position = Vector2.ZERO
	transitioned.emit(immovable_state)
