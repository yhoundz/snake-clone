extends Area2D
class_name playerNode

enum order {lead, mid, last}

@export var lead: order
@export var posX: int
@export var posY: int
@export var orderNum: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setOrder(to: order) -> void:
	lead = to

func getOrder() -> order:
	return lead

func getX() -> int:
	return posX

func getY() -> int:
	return posY

func setX(x: int) -> void:
	posX = x

func setY(y: int) -> void:
	posY = y

func setOrderNum(num: int) -> void:
	orderNum = num

func getOrderNum() -> int:
	return orderNum

