extends ProgressBar

@export var faction: Faction

func _enter_tree() -> void:
	EventBus.reputation_change.connect(_on_reputation_change)

func _ready() -> void:
	var stylebox: StyleBoxFlat = StyleBoxFlat.new()
	stylebox.bg_color = faction.color
	add_theme_stylebox_override("fill", stylebox)

func _on_reputation_change(reputation_faction: Faction, new_val: int) -> void:
	if faction != reputation_faction:
		return

	value = new_val
