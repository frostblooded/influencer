class_name RockItem
extends Item

@export var particles: CPUParticles2D

func on_unit_crash(unit_move_direction: Enums.Direction) -> void:
    var direction: Enums.Direction = Enums.get_reverse_direction(unit_move_direction)
    particles.direction = Enums.direction_to_vec2(direction)
    particles.restart()
