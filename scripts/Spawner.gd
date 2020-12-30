extends Node2D

export (float) var interval = 5.0

var spawn_node;


func _ready():
	# spawn할 노드를 찾아서 resource file name을 보관한다.
	var nodes = get_children()
	for node in nodes:
		if node is Timer:
			continue
		
		var n:Node = node
		spawn_node = load(n.filename)
		n.call_deferred("queue_free")
		break
	$Timer.start(interval)
	
func _on_Timer_timeout():
	if StaticData.game_state != Define.GameState.play:
		return
		
	if spawn_node == null:
		return
	var node = spawn_node.instance()
	add_child(node)
	
