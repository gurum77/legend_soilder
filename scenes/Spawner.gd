extends Node2D

export (float) var spawn_interval = 5

var spawn_node:Resource

func _ready():
	var nodes = get_children()
	# timer를 제외한 노드를 spawn 한다
	for node in nodes:
		if node is Timer:
			continue
		
		# 리소스만 load해 놓고원래 것은 삭제한다.
		spawn_node = load(node.filename)
		break
		
	# spawn 할 노드가 있으면 timer를 작동시킨다
	if not spawn_node == null:
		$Timer.start(spawn_interval)



func _on_Timer_timeout():
	if spawn_node == null:
		return
	var new_node:Node2D = spawn_node.instance()
	new_node.position = Vector2.ZERO
	
	add_child(new_node)
	
