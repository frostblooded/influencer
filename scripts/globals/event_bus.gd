extends Node

signal on_end_turn_button_pressed
signal performed_actions
signal level_start
signal level_victory(faction: Faction)
signal start_turn(faction: Faction)
signal player_turn_end
signal reputation_change(faction: Faction, new_value: int)
