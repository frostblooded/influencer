class_name Helpers

static func safe_connect(sig: Signal, callable: Callable) -> void:
    var result: int = sig.connect(callable)
    assert(result == OK)
