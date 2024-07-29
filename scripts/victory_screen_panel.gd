extends Panel

@export var faction_label: Label
@export var next_level_button: Button
@export var next_level_scene_path: String

func _enter_tree() -> void:
	Helpers.safe_connect(EventBus.game_victory, show_winner)
	Helpers.safe_connect(next_level_button.pressed, next_level)

func _ready() -> void:
	hide()

func show_winner(faction: Enums.Faction) -> void:
	show()
	faction_label.text = Enums.Faction.find_key(faction)

	if faction == Enums.Faction.Green:
		faction_label.add_theme_color_override("font_color", "4dff4d")
	elif faction == Enums.Faction.Red:
		faction_label.add_theme_color_override("font_color", "ff4d4d")
	else:
		push_error("Unknown faction")

	if next_level_scene_path.is_empty():
		next_level_button.hide()

func next_level() -> void:
	if next_level_scene_path.is_empty():
		return

	Helpers.safe_change_scene_to_file(get_tree(), next_level_scene_path)
