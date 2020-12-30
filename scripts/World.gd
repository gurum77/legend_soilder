extends Node2D

var pausePanel = preload("res://scenes/Pause.tscn")

func _ready():
	StaticData.current_score_for_stage = 0
	
# pause
func _on_PauseButton_pressed():
	get_tree().paused = true
	
	var ins = pausePanel.instance()
	$CanvasLayer.add_child(ins)
	
# enemy가 죽을때마다 게임 오버인지 체크한다.
func on_enemy_dead():
	# play 중이 아니라면 리턴
	if StaticData.game_state != Define.GameState.play:
		return
		
	if StaticData.requirement_score_for_stage <= StaticData.current_score_for_stage:
		StaticData.game_state = Define.GameState.over
		$CanvasLayer.add_child(load("res://scenes/Victory.tscn").instance())
	
	
