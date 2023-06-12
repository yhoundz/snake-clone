extends Node2D
class_name level

func _ready() -> void:
	get_node("Apple").spawn()

func _process(delta: float) -> void:
	pass

static func computeCoords(x: int, y:int) -> Array[int]:
	return [10 * y, 10 * x]

