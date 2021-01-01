extends Node2D

export (float) var interval = 5.0

var spawn_node;


func _ready():
	# spawn할 노드를 찾아서 resource file name을 보관한다.
	var nodes = get_children()
	for node in nodes:
		if node is Timer or node is Tween:
			continue
		
		var n:Node = node
		spawn_node = load(n.filename)
		n.call_deferred("queue_free")
		break
	$Timer.start(interval)
	
func _on_Timer_timeout():
	if spawn_node == null:
		return
		
	# 게임중이 아니라면 spawn하지 않는
	if StaticData.game_state != Define.GameState.play:
		return
	
	# 필요한 만큼 spawn을 했다면 더이상 spawn하지 않는다.
	if StaticData.spawned_score_for_stage >= StaticData.requirement_score_for_stage:
		return
			
	
	
	var node = spawn_node.instance()
	add_child(node)
	if node is Enemy:
		var enemy:Enemy = node
		enemy.HP = Table.get_enemy_hp(enemy.HP, StaticData.current_stage)
		StaticData.spawned_score_for_stage += enemy.get_score()
		# 점점 커지게 만들어 준다.
		$Tween.interpolate_property(enemy, "scale", Vector2(0.1, 0.1), Vector2(1, 1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		
	
	
	
	
