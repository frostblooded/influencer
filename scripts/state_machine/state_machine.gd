class_name StateMachine
extends Node

@export var _initial_state: State

@onready var _parent: Node = get_parent() as Node

var _states: Dictionary

var _current_state: State:
	set(val):
		if _current_state:
			_current_state.exit(_parent)

		_current_state = val
		_current_state.enter(_parent)

func _ready() -> void:
	for child: State in get_children():
		_states[child.name] = child
		Helpers.safe_connect(child.transitioned, on_state_transitioned)
	
	_current_state = _initial_state

func _process(delta: float) -> void:
	if _current_state:
		_current_state.state_process(delta, _parent)

func on_state_transitioned(state: State, new_state_name: String) -> void:
	assert(state == _current_state)

	var new_state: State = _states[new_state_name]
	assert(new_state)

	_current_state = new_state
