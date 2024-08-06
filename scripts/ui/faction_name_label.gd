extends Label

func _enter_tree() -> void:
	Helpers.safe_connect(EventBus.start_turn, on_start_turn)

func on_start_turn(faction: Faction) -> void:
	text = faction.name
	add_theme_color_override("font_color", faction.color)
