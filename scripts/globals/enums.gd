class_name Enums

enum Direction {
    None,
    Top,
    Right,
    Bottom,
    Left
}

static func direction_to_vec2(direction: Direction) -> Vector2:
    match (direction):
        Direction.Top:
            return Vector2.UP
        Direction.Right:
            return Vector2.RIGHT
        Direction.Bottom:
            return Vector2.DOWN
        Direction.Left:
            return Vector2.LEFT
    
    return Vector2.ZERO

static func direction_to_angle(direction: Direction) -> float:
    return direction_to_vec2(direction).angle()

static func get_next_clockwise_direction(direction: Direction) -> Direction:
    match (direction):
        Direction.Right:
            return Direction.Bottom
        Direction.Bottom:
            return Direction.Left
        Direction.Left:
            return Direction.Top
        Direction.Top:
            return Direction.Right
    
    return Direction.None
