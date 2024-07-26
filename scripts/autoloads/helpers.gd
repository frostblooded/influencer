class_name Helpers

static func safe_connect(sig: Signal, callable: Callable) -> void:
    var result: int = sig.connect(callable)
    assert(result == OK)

# We don't really need this "safe" disconnect because disconnect is already safe
# but I wanted to have a counterpart to safe_connect().
static func safe_disconnect(sig: Signal, callable: Callable) -> void:
    sig.disconnect(callable)

static func safe_reload_current_scene(tree: SceneTree) -> void:
    var result: int = tree.reload_current_scene()
    assert(result == OK)
