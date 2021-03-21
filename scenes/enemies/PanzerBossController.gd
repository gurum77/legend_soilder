extends Node2D

enum Step{normal_fire, dash}

onready var enemy_ai = get_parent().get_node_or_null("EnemyAI")

# 1 : 일반 공격 1 cycle후 휴식
# 2 : player에게 돌진 (player를 30m지나치는 거리까지 돌진)
var current_step = Step.normal_fire
var waiting_next_step = false
func _ready():
	current_step = Step.normal_fire

func wait_next_step(sec):
	waiting_next_step = true
	yield(get_tree().create_timer(3), "timeout")
	waiting_next_step = false
	
func _process(delta):
	if waiting_next_step:
		return
		
	if current_step == Step.normal_fire:
		if normal_fire_completed():
			# 3초후 dash
			wait_next_step(3)
			current_step = Step.dash
			dash()
	elif current_step == Step.dash:
		if dash_completed():
			# 3초후 일반공격으로 전환
			wait_next_step(3)
			current_step = Step.normal_fire
			normal_fire()

func normal_fire_completed()->bool:
	return enemy_ai.enemy.get_body().is_rest_to_fire()
	
# dash가 끝났는지?
func dash_completed()->bool:
	return enemy_ai.enemy.get_body().arrived_in_target_position_to_move()
		
func dash():
	# player를 찾는다.
	var player = enemy_ai.find_player()
	if player == null:
		return
	
	# 목표지점을 설정
	# player방향으로 player를 지나친도록 설정
	var dir:Vector2 = player.global_position - self.global_position
	dir = dir.normalized()
	var target_position = player.global_position + dir * 200
	enemy_ai.enemy.get_body().target_position_to_move = target_position
	enemy_ai.enemy.get_body().target_position_buffer_to_move.resize(0)
	enemy_ai.get_enemy_ai_move().enabled_find_target_position = false
			
	# 목표 지점에 도달할때까지 dash를 한다.(speed를 올린다)
	get_parent().get_body().speed = 200
	
	# normal_fire까지는 공격 중지
	enemy_ai.in_attack = false
	enemy_ai.disabled_player_detection_timer = true
	
	# dash 최대 시간 체크용 timer
	$DashTimer.start()
	
func normal_fire():
	get_parent().get_body().speed = 50
	enemy_ai.get_enemy_ai_move().enabled_find_target_position = true
	enemy_ai.disabled_player_detection_timer = false
	pass

# dash timer
# dash를 완료하지 못 해도 timer가 끝나면 다음 공격으로 넘어가야함
func _on_DashTimer_timeout():
	if current_step == Step.dash:
		current_step = Step.normal_fire
		normal_fire()
