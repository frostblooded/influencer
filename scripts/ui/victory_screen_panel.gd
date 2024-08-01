extends Panel

@export var faction_label: Label
@export var next_level_button: Button
@export var next_level_scene_path: String

func _enter_tree() -> void:
	Helpers.safe_connect(EventBus.level_victory, show_winner)
	Helpers.safe_connect(next_level_button.pressed, load_next_level)

func _ready() -> void:
	hide()

func show_winner(faction: Faction) -> void:
	show()

	faction_label.text = faction.name
	faction_label.add_theme_color_override("font_color", faction.color)

	if next_level_scene_path.is_empty():
		next_level_button.hide()

func load_next_level() -> void:
	if next_level_scene_path.is_empty():
		return

	Helpers.safe_change_scene_to_file(get_tree(), next_level_scene_path)
