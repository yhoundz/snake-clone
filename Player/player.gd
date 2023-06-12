extends Node2D
class_name player

enum direction {up, down, left, right}
enum state {alive, dead}

var dir: direction
var lastDir: direction
var timer: Node
var currLength: int
var playerNodes: Array[Node]
var playerState: state
var score: int
var nodeAdded: bool = false

@onready var playerNodeScene: PackedScene = load("res://Player/player_node.tscn")

func _ready() -> void:
	score = 0
	playerState = state.alive
	setPlayerNodes()
	currLength = len(playerNodes)
	dir = direction.right
	lastDir = direction.left
	timer = get_node("actionTimer")
	timer.start()

func _process(delta: float) -> void:
	setDir()

func setDir() -> void:
	if Input.is_action_just_pressed("ui_up") and dir != direction.down and lastDir != direction.down:
		dir = direction.up
	if Input.is_action_just_pressed("ui_down") and dir != direction.up and lastDir != direction.up:
		dir = direction.down
	if Input.is_action_just_pressed("ui_right") and dir != direction.left and lastDir != direction.left:
		dir = direction.right
	if Input.is_action_just_pressed("ui_left") and dir != direction.right and lastDir != direction.right:
		dir = direction.left

func setPlayerNodes() -> void:
	for i in get_node("PlayerNodes").get_children():
		playerNodes.append(i)
		var xc: Array[int] = level.computeCoords(i.getX(), i.getY())
		i.set_global_position(Vector2(xc[1], xc[0]))
	sortPlayerNodes()
	

func getPlayerNodes() -> Array[Node]:
	return playerNodes

func addNode() -> void:
	var newNode = playerNodeScene.instantiate()
	get_node("PlayerNodes").call_deferred("add_child", newNode)
	newNode.setOrder(newNode.order.lead)
	newNode.setOrderNum(currLength + 1)
	currLength += 1
	playerNodes.append(newNode)
	setNodePos(newNode)

func setNodePos(v: Node) -> void:
	var j: int = 0
	while true:
		if j >= len(playerNodes):
			break
		var x: Node = playerNodes[j]
		if x.getOrderNum() == 1 or x.getOrder() == x.order.lead:
			match dir:
				direction.up:
					v.setY(x.getY() - 1)
					v.setX(x.getX())
					lastDir = direction.up
				direction.down:
					v.setY(x.getY() + 1)
					v.setX(x.getX())
					lastDir = direction.down
				direction.right:
					v.setY(x.getY())
					v.setX(x.getX() + 1)
					lastDir = direction.right
				direction.left:
					v.setY(x.getY())
					v.setX(x.getX() - 1)
					lastDir = direction.left
					
			for i in playerNodes:
				i.setOrderNum(i.getOrderNum() + 1)
				
				if i.getOrderNum() > currLength:
					i.setOrderNum(1)
					i.setOrder(i.order.lead)
				elif i.getOrderNum() == currLength:
					i.setOrder(i.order.last)
				else:
					i.setOrder(i.order.mid)
			
			sortPlayerNodes()
			if v.getX() >= 32:
				v.setX(0)
			elif v.getX() < 0:
				v.setX(31)
			if v.getY() >= 18:
				v.setY(0)
			elif v.getY() < 0:
				v.setY(17)
			var xc: Array[int] = level.computeCoords(v.getX(), v.getY())
			v.set_global_position(Vector2(xc[1], xc[0]))
			break
		j += 1

func sortPlayerNodes() -> void:
	var x: Node
	var i: int = 1
	for num in range(i, len(playerNodes)):
		x = playerNodes[num]
		var j: int = num - 1
		while(j >= 0 and playerNodes[j].getOrderNum() > x.getOrderNum()):
			playerNodes[j + 1] = playerNodes[j]
			j -= 1
		playerNodes[j + 1] = x

func _on_action_timer_timeout() -> void:
	if nodeAdded:
		addNode()
		nodeAdded = false
	else:
		for i in playerNodes:
			if i.getOrder() == i.order.last or i.getOrderNum() == currLength:
				setNodePos(i)
				break
	checkCollisions()

func checkCollisions() -> void:
	for i in playerNodes:
		if i.getOrder() == i.order.lead:
			for j in playerNodes:
				if i != j and i.getX() == j.getX() and i.getY() == j.getY():
					die()

func die() -> void:
	playerState == state.dead
	timer.stop()
	get_tree().reload_current_scene()

func increaseScore() -> void:
	score += 1
