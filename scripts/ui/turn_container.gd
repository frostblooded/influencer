extends VBoxContainer

@export var faction_name_label: Label
@export var end_turn_button: Button
@export var player_faction: Faction

func _enter_tree() -> void:
	Helpers.safe_connect(EventBus.start_turn, _on_start_turn)

func _on_start_turn(faction: Faction) -> void:
	faction_name_label.text = faction.name
	faction_name_label.add_theme_color_override("font_color", faction.color)
	end_turn_button.disabled = faction != player_faction
