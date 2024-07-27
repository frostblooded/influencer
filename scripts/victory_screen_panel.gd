extends Panel

@export var faction_label: Label
@export var reload_level_button: Button

func _enter_tree() -> void:
	Helpers.safe_connect(EventBus.game_victory, show_winner)
	Helpers.safe_connect(reload_level_button.pressed, reload_level)

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

func reload_level() -> void:
	Helpers.safe_reload_current_scene(get_tree())
