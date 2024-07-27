class_name GridCell
extends Cell

@export var _top_action_sprite_2d: Node2D
@export var _right_action_sprite_2d: Node2D
@export var _bottom_action_sprite_2d: Node2D
@export var _left_action_sprite_2d: Node2D
@export var _green_faction_sprite_2d: Sprite2D
@export var _red_faction_sprite_2d: Sprite2D

func _ready() -> void:
    super._ready()
    hide_all_action_sprite_2ds()

    _green_faction_sprite_2d.hide()
    _red_faction_sprite_2d.hide()

func set_action_sprite_2d(texture: Texture2D, direction: Enums.Direction) -> void:
    hide_all_action_sprite_2ds()
    var action_sprite_2d: Sprite2D = get_action_sprite_2d_for_direction(direction)
    action_sprite_2d.texture = texture
    action_sprite_2d.show()

func reset_action_sprite_2d() -> void:
    hide_all_action_sprite_2ds()

func hide_all_action_sprite_2ds() -> void:
    _top_action_sprite_2d.hide()
    _right_action_sprite_2d.hide()
    _bottom_action_sprite_2d.hide()
    _left_action_sprite_2d.hide()

func get_action_sprite_2d_for_direction(direction: Enums.Direction) -> Sprite2D:
    match direction:
        Enums.Direction.Top:
            return _top_action_sprite_2d
        Enums.Direction.Right:
            return _right_action_sprite_2d
        Enums.Direction.Bottom:
            return _bottom_action_sprite_2d
        Enums.Direction.Left:
            return _left_action_sprite_2d
        _:
            push_error("Trying to get action sprite 2d container for unknown direction")
            return null

func add_to_container(node: Node) -> void:
    super.add_to_container(node)
    var unit: Unit = node as Unit
    if unit:
        if unit.faction == Enums.Faction.Green:
            _green_faction_sprite_2d.show()
            _red_faction_sprite_2d.hide()
        elif unit.faction == Enums.Faction.Red:
            _green_faction_sprite_2d.hide()
            _red_faction_sprite_2d.show()
        else:
            push_error("Unknown faction")

func empty_container() -> void:
    super.empty_container()
    _green_faction_sprite_2d.hide()
    _red_faction_sprite_2d.hide()
