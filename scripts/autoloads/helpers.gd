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

static func safe_change_scene_to_packed(tree: SceneTree, packed: PackedScene) -> void:
    var result: int = tree.change_scene_to_packed(packed)
    assert(result == OK)

static func safe_change_scene_to_file(tree: SceneTree, file: String) -> void:
    var result: int = tree.change_scene_to_file(file)
    assert(result == OK)

static func orphan(node: Node) -> void:
    var parent: Node = node.get_parent()
    parent.remove_child(node)

static func change_parent(node: Node, new_parent: Node) -> void:
    orphan(node)
    new_parent.add_child(node)
