extends Node2D


func _process(delta):
	# player를 찾아서 여기로 이동시킨다.
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return
	players[0].global_position = global_position
	call_deferred("queue_free")
