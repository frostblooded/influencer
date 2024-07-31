class_name IdleState
extends State

@export var area_2d: Area2D
@export var dragged_state: State

func enter(_parent: Node) -> void:
	Helpers.safe_connect(area_2d.input_event, handle_mouse_event)

func exit(_parent: Node) -> void:
	Helpers.safe_disconnect(area_2d.input_event, handle_mouse_event)

func handle_mouse_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var mouse_button_event: InputEventMouseButton = event as InputEventMouseButton

		if mouse_button_event.is_pressed():
			if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
				transitioned.emit(dragged_state)
