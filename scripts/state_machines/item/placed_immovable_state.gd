class_name PlacedImmovableState
extends ItemState

func can_be_moved() -> bool:
    return false

func is_placed_in_world() -> bool:
    return true
