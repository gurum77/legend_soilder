extends Node2D

# export var
onready var enemy_ai:EnemyAI = get_parent()
var target_position:Vector2

# enemy의 moving 상태
enum {patrol, move, avoid}
var state = patrol


func get_ai_level()->int:
	return enemy_ai.level

func _physics_process(delta):
	if enemy_ai == null:
		return
	if StaticData.game_state != Define.GameState.play:
		return
		
	# state를 결정한다.
	determine_state()
	
# state를 결정한다.
# patrol, move, avoid를 결정한
func determine_state():
	# 등급에 상관없이 patrol중 시야에 들어오면 move 상태로 바꾼다.
	if state == patrol && enemy_ai.in_eye:
		state = move

# 목표 위치를 찾는다.
func _on_FindTargetTimer_timeout():
	match get_ai_level():
		EnemyAI.Level.newbie:
			find_target_position_newbie()
		EnemyAI.Level.intermediate:
			find_target_position_intermediate()
		EnemyAI.Level.expert:
			pass
		EnemyAI.Level.crazy:
			pass
		
# newbie의 목표지점 찾기
func find_target_position_newbie():
	
	# newbie는 무조건 player로 돌진이다
	match state:
		patrol:
			pass
		move:
			var player = enemy_ai.find_player()
			# player를 못 찾으면 목표지점을 자신으로 한
			if player == null:
				enemy_ai.enemy.get_body().target_position_to_move = self.global_position
				return
				
			enemy_ai.enemy.get_body().target_position_to_move = player.global_position
		avoid:
			pass
	
# intermediate의 목표지점 찾기
func find_target_position_intermediate():
	pass
