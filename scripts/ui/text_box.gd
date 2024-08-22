class_name TextBox
extends MarginContainer

@export var label: Label
@export var timer: Timer

const MAX_WIDTH: int = 256

var text: String = ""
var letter_index: int = 0

var letter_time: float = 0.03
var space_time: float = 0.06
var punctuation_time: float = 0.2

var tracked_node: Node2D

func _ready() -> void:
	timer.timeout.connect(_display_letter)

func _process(_delta: float) -> void:
	if !is_instance_valid(tracked_node):
		tracked_node = null

	update_position()

func update_position() -> void:
	if !tracked_node:
		return

	global_position = tracked_node.global_position
	global_position.x -= size.x / 2
	global_position.y -= size.y + 44

	var screen_rect: Rect2 = get_viewport().get_visible_rect()
	global_position = global_position.clamp(Vector2.ZERO, screen_rect.size)

func display_text(text_to_display: String) -> void:
	text = text_to_display
	label.text = text_to_display

	await resized # wait for resize based on set text
	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for x resize
		await resized # wait for y resize
		custom_minimum_size.y = size.y
	
	update_position()

	label.text = ""
	_display_letter()

func _display_letter() -> void:
	label.text += text[letter_index]

	letter_index += 1
	if letter_index >= text.length():
		return
	
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
