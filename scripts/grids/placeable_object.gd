class_name PlaceableObject
extends Node2D

var cell: GridCell

func on_spawned_in_world() -> void:
    pass

func destroy() -> void:
    queue_free()
    cell.empty_container()

func play_destroy_animation(direction: Enums.Direction, promise: Promise) -> void:
    var rotation_tween: Tween = create_tween()
    rotation_tween.tween_property(self, "rotation", 3 * TAU, 0.5).as_relative()

    var scaling_tween: Tween = create_tween()
    scaling_tween.tween_property(self, "scale", Vector2.ZERO, 0.5)

    var translating_tween: Tween = create_tween()
    var direction_vec: Vector2 = Enums.direction_to_vec2(direction)
    translating_tween.tween_property(self, "global_position", direction_vec * 400, 0.5).as_relative()

    await rotation_tween.finished
    await scaling_tween.finished
    await translating_tween.finished

    promise.resolve()

func _to_string() -> String:
    return str(get_instance_id())
