extends Node2D

export (float) var interval = 5.0
# stage별 step이 requirement_step보다 작거나 같을때만 spawn된다.
export (int) var requirement_step = 1

var spawn_position
var spawn_node
onready var si:StageInformation = StaticData.get_current_stage_information()

func _ready():
	# spawn할 노드를 찾아서 resource file name을 보관한다.
	var nodes = get_children()
	for node in nodes:
		if node is Timer or node is Tween:
			continue
		
		var n:Node2D = node
		spawn_position = n.position
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
		
	# step이 충족되지 않으면 spawn하지 않는다
	if si.current_step < requirement_step:
		return
		
	
	# 필요한 만큼 spawn을 했다면 더이상 spawn하지 않는다.
	if StaticData.spawned_score_for_stage >= StaticData.requirement_score_for_stage:
		return

	
	var node:Node2D = spawn_node.instance()
	node.position = spawn_position
	
	add_child(node)
	if node is Enemy:
		var enemy:Enemy = node
		enemy.set_HP(Table.get_enemy_hp(enemy.HP, StaticData.get_current_stage_information()))
		StaticData.spawned_score_for_stage += enemy.get_score()
		# 점점 커지게 만들어 준다.
		$Tween.interpolate_property(enemy, "scale", Vector2(0.1, 0.1), Vector2(1, 1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		# 앞으로 조금 밀어준다.
		enemy.get_body().target_position_to_move = global_position + Vector2(50, 50)
		
		
	
	
	
	
