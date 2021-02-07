extends Node2D
class_name EnemyAI

# ai 의 레벨
enum Level {newbie, intermediate, expert, crazy}

# ai가 움직일 실제 노드
var enemy:Node2D

export (Level) var level = Level.newbie
export (float) var distance_in_eye = 250		# 시야 거리
export (float) var distance_in_attack = 100		# 사정 거리
export (float) var distance_in_dangerous = 50	# 위험 감지 거리

var in_eye = false
var in_attack = false
var in_dangerous = false
var debugging = false

func _ready():
	var parent = get_parent()
	if parent is Viewport:
		return
		
	enemy = parent
	if enemy == null:
		return
	
	# 사정거리를 결정한다.
	distance_in_attack = Table.get_weapon_bullet_distance(enemy.get_body().weapon)
	distance_in_eye = distance_in_attack * 2
	
	# 디버깅중일때는 path를 표시하고 사거리 원을 표시한다
	if !debugging:
		$EnemyAI_Move/PatrolPath.visible = false
		
	#update()
	

func _draw():
	if !debugging:
		return
	var eye_color:Color = Color.green
	eye_color.a = 0.1
	draw_circle(position, distance_in_eye, eye_color)
	
	var attack_color:Color = Color.red
	attack_color.a = 0.1
	draw_circle(position, distance_in_attack, attack_color)
	
	var dangerous_color:Color = Color.orange
	dangerous_color.a = 0.1
	draw_circle(position, distance_in_dangerous, dangerous_color)
	
	# 상태 표시
	$EyeLabel.text = "Eye:"+String(in_eye)
	$AttackLabel.text = "Att:"+String(in_attack)
	$DangerousLabel.text = "Dan:" + String(in_dangerous)
	$MoveStateLabel.text = "Move:" + String($EnemyAI_Move.state)

func _on_DrawTimer_timeout():
	if enemy == null:
		return
		
	#update()


# player 없음으로 설정한다.
func set_no_player():
	in_eye = false
	in_attack = false
	in_dangerous = false
	
# player를 찾는다
func find_player()->Node:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return null
	return players[0]
	
# player를 찾아서 현재 상태를 기록한다.
func _on_PlayerDetectionTimer_timeout():
	if enemy == null:
		return
		
	set_no_player()
	
	var player:Node2D = find_player()
	if player == null:
		return
	
	# player 까지 거리
	var distance = player.global_position.distance_to(self.global_position)
	if distance < distance_in_attack:
		in_attack = true
	if distance < distance_in_dangerous:
		in_dangerous = true
	if distance < distance_in_eye:
		in_eye = true

