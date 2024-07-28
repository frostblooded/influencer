extends Node2D

@export var starting_elements: Array[PackedScene] = []

func _ready() -> void:
	assert(starting_elements.size() <= get_child_count())

	var child_idx: int = 0
	for element_scene: PackedScene in starting_elements:
		var child: Node = get_child(child_idx)
		child_idx += 1
		var element_instance: Node2D = element_scene.instantiate() as Node2D
		child.add_child(element_instance)
