extends Node2D

# 지정된 spawn 간격(0이면 기본간격으로 됨)
export (float) var specify_spawn_interval = 0

# stage별 step이 requirement_step보다 작거나 같을때만 spawn된다.
export (int) var min_step = 1
# 최대 스탭이 지정된 경우 최대 스탭 이후로는 spawn 되지 않는다.
export (int) var max_step = 5
export (bool) var disabled = false
var spawn_position
var spawn_node
var interval = Define.default_spawn_interval
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
		
	# 노드의 종류에 따른 기본 interval 설정
	if spawn_node != null && spawn_node is Enemy:
		var enemy = spawn_node as Enemy
		if enemy.get_body().enemy_type == EnemyBody.EnemyType.airplane:
			interval = Define.default_spawn_interval_airplane
			
	$Timer.start(interval)
	

func _on_Timer_timeout():
	if spawn_node == null:
		return
	if disabled:
		return
		
	# 게임중이 아니라면 spawn하지 않는
	if StaticData.game_state != Define.GameState.play:
		return
		
	# step이 충족되지 않으면 spawn하지 않는다
	if si.current_step < min_step:
		return
	if si.current_step > max_step:
		return
		
	
	# 필요한 만큼 spawn을 했다면 더이상 spawn하지 않는다.
	if StaticData.spawned_score_for_stage >= StaticData.requirement_score_for_stage:
		return

	
	var node:Node2D = spawn_node.instance()
	node.position = spawn_position
	
	add_child(node)
	if node is Enemy:
		var enemy:Enemy = node
		
		var size = enemy.get_body_collision_size()
		
		# path_finder 설정
		var world_node = get_tree().root.get_node_or_null("World")
		if world_node != null:
			var path_finder_name = "PathFinder"
			if size > 32:
				path_finder_name = "PathFinder64x64"
			var path_finder = world_node.get_node_or_null(path_finder_name)
			enemy.set_path_finder(path_finder)
			
		# hp 를 stage에 맞게 설정
		enemy.set_HP(Table.get_enemy_hp(enemy.HP, StaticData.get_current_stage_information()))
		
		# 지금까지 spawn 된 점수를 기록
		StaticData.spawned_score_for_stage += enemy.get_score()
		
		# 점점 커지게 만들어 준다.
		$Tween.interpolate_property(enemy, "scale", Vector2(0.1, 0.1), Vector2(1, 1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()		
