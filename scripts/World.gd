extends Node2D

var pausePanel = preload("res://scenes/Pause.tscn")

func _ready():

	# 게임을 시작하면 현재  stage에 대한 데이타를 초기화 한다
	StaticData.current_score_for_stage = 0
	StaticData.current_stage_money = 0
	StaticData.requirement_score_for_stage = Table.get_stage_clear_score(StaticData.get_current_stage_information())
	StaticData.spawned_score_for_stage = 0
	$CanvasLayer/StageProgress.update()
	
	# revival 데이타 초기화
	StaticData.has_revival_chance = true
	
	# debug information
	update_debug_information()
	
func update_debug_information():
	var si = StaticData.get_current_stage_information()
	var line1 = "Stage name : " + StaticData.current_stage_name
	var line2 = "\nStage level - step : " + str(si.level) + "-" + str(si.current_step)
	var line3 = "\nStage position : " + str(Table.get_stage_position(si))
	var line4 = "\nClear score : " + str(StaticData.requirement_score_for_stage as int)
	var line5 = "\nSpawned score : " + str(StaticData.spawned_score_for_stage as int)
	$CanvasLayer/DebugLabel.text = line1 + line2 + line3 + line4 + line5
	

# pause
func _on_PauseButton_pressed():
	get_tree().paused = true
	
	var ins = pausePanel.instance()
	$CanvasLayer.add_child(ins)
	
# 게임 오버
func game_over(var victory:bool):
	StaticData.game_state = Define.GameState.over
	
	# 적이 죽고 item을 만드는 시간이 있다 0.5초 대기후에 게임 오버한다.
	yield(get_tree().create_timer(0.5), "timeout")
	
	# item을 모두 먹는다.
	var items = get_tree().get_nodes_in_group("item")
	for item in items:
		item.get_item()
		
	# item을 먹는 시간이 있으니 1초 대기 후에 계속 진행한다.
	yield(get_tree().create_timer(1), "timeout")
	
	# 승리시 현재 stage 증가
	# next 버튼을 안누르고 바로 home으로 갈수도 있기 때문에 여기서 미리 올려준다
	if victory == true:
		var si = StaticData.get_current_stage_information()
		if si != null:
			
			si.current_step += 1
			
	# game data 저장
	StaticData.save_game()
	
	# 결과 표시 
	if victory:
		$CanvasLayer.add_child(load("res://scenes/Victory.tscn").instance())
	else:
		$CanvasLayer.add_child(load("res://scenes/Failed.tscn").instance())	
	
		
func _process(_delta):
	update_debug_information()
		
# enemy가 죽을때마다 게임 오버인지 체크한다.
func on_Enemy_dead():
	# play 중이 아니라면 리턴
	if StaticData.game_state != Define.GameState.play:
		return
	if StaticData.requirement_score_for_stage <= StaticData.current_score_for_stage:
		game_over(true)
	
		
# player가 죽으면 게임 오버	
func on_Player_dead():
	# play 중이 아니라면 리턴
	if StaticData.game_state != Define.GameState.play:
		return
	game_over(false)	
