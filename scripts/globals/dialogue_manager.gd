extends Node

@onready var text_box_scene: PackedScene = preload("res://scenes/ui/text_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index: int = 0

var text_box: TextBox
var tracked_node: Node2D

var is_dialogue_active: bool = false

func _process(_delta: float) -> void:
    if !is_dialogue_active:
        return

    if !is_instance_valid(tracked_node):
        end_dialogue()

func start_dialogue(node_to_track: Node2D, lines: Array[String]) -> void:
    if is_dialogue_active:
        return
    
    dialog_lines = lines
    tracked_node = node_to_track
    _show_text_box()

    is_dialogue_active = true

func end_dialogue() -> void:
    if text_box:
        text_box.queue_free()

    text_box = null
    tracked_node = null
    is_dialogue_active = false
    current_line_index = 0

func _show_text_box() -> void:
    text_box = text_box_scene.instantiate()
    get_tree().root.add_child(text_box)
    text_box.tracked_node = tracked_node
    text_box.display_text(dialog_lines[current_line_index])

func advance_dialogue() -> void:
    if !is_dialogue_active:
        return

    text_box.queue_free()

    current_line_index += 1
    if current_line_index >= dialog_lines.size():
        end_dialogue()
        return
    
    _show_text_box()

func _unhandled_input(event: InputEvent) -> void:
    if (event.is_action_pressed("advance_dialogue")):
        advance_dialogue()
