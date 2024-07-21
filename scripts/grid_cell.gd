extends Node2D

@export var area_2d: Area2D
@export var default_sprite_2d: Sprite2D
@export var hovered_sprite_2d: Sprite2D

func _ready() -> void:
	Helpers.safe_connect(area_2d.mouse_entered, on_mouse_entered)
	Helpers.safe_connect(area_2d.mouse_exited, on_mouse_exited)

	default_sprite_2d.show()
	hovered_sprite_2d.hide()

func on_mouse_entered() -> void:
	default_sprite_2d.hide()
	hovered_sprite_2d.show()

func on_mouse_exited() -> void:
	default_sprite_2d.show()
	hovered_sprite_2d.hide()
