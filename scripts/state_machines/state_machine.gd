class_name StateMachine
extends Node

@export var _initial_state: State

@onready var _parent: Node = get_parent() as Node

var _current_state: State:
	set(val):
		if _current_state:
			_current_state.exit(_parent)

		_current_state = val
		_current_state.enter(_parent)

func _ready() -> void:
	for child: State in get_children():
		Helpers.safe_connect(child.transitioned, on_state_transitioned)
	
	_current_state = _initial_state

func _process(delta: float) -> void:
	if _current_state:
		_current_state.state_process(delta, _parent)

func on_state_transitioned(new_state: State) -> void:
	_current_state = new_state
