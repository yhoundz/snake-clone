extends Area2D
class_name apple

@export var posX: int
@export var posY: int

func _ready() -> void:
	spawn()

func spawn() -> void:
	posX = randi() % 32
	posY = randi() % 18
	
	var i: Array = level.computeCoords(posX, posY)
	set_global_position(Vector2(i[1], i[0]))

func getY() -> int:
	return posY

func getX() -> int:
	return posX

func _on_area_entered(area) -> void:
	if area is playerNode:
		spawn()
		area.get_parent().get_parent().nodeAdded = true
		
