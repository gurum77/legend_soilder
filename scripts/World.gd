extends Node2D

export var specify_stage = -1

var pausePanel = preload("res://scenes/Pause.tscn")

func _ready():
	if specify_stage > -1:
		StaticData.current_stage = specify_stage
		
	# 게임을 시작하면 현재  stage에 대한 데이타를 초기화 한다
	StaticData.current_score_for_stage = 0
	StaticData.current_stage_money = 0
	StaticData.requirement_score_for_stage = Table.get_stage_clear_score(StaticData.current_stage)
	StaticData.spawned_score_for_stage = 0
	$CanvasLayer/StageProgress.update()
	
	# debug information
	update_debug_information()
	
func update_debug_information():
	var line1 = "Stage : " + str(StaticData.current_stage)
	var line2 = "\nClear score : " + str(StaticData.requirement_score_for_stage as int)
	var line3 = "\nSpawned score : " + str(StaticData.spawned_score_for_stage as int)
	$CanvasLayer/DebugLabel.text = line1 + line2 + line3
	

# pause
func _on_PauseButton_pressed():
	get_tree().paused = true
	
	var ins = pausePanel.instance()
	$CanvasLayer.add_child(ins)
	
# 게임 오버
func game_over(var victory:bool):
	StaticData.game_state = Define.GameState.over
	# 승리시 현재 stage 증가
	# next 버튼을 안누르고 바로 home으로 갈수도 있기 때문에 여기서 미리 올려준다
	if victory:
		StaticData.current_stage += 1
	# game data 저장
	StaticData.save_game()
	# 결과 표시 
	if victory:
		$CanvasLayer.add_child(load("res://scenes/Victory.tscn").instance())
	else:
		$CanvasLayer.add_child(load("res://scenes/Failed.tscn").instance())	
func _process(delta):
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
