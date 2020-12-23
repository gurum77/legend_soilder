extends Node2D
class_name EnemyAI

# ai가 움직일 실제 노드
var enemy:Node2D

export (float) var distance_in_eye = 250		# 시야 거리
export (float) var distance_in_attack = 100	# 사정 거리
export (float) var distance_in_dangerous = 50	# 위험 감지 거리

var in_eye = false
var in_attack = false
var in_dangerous = false

func _ready():
	enemy = get_parent()
	if enemy == null:
		return
	update()
	

func _draw():
	var eye_color:Color = Color.green
	eye_color.a = 0.1
	draw_circle(position, distance_in_eye, eye_color)
	
	var attack_color:Color = Color.red
	attack_color.a = 0.1
	draw_circle(position, distance_in_attack, attack_color)
	
	var dangerous_color:Color = Color.orange
	dangerous_color.a = 0.1
	draw_circle(position, distance_in_dangerous, dangerous_color)
	

func _on_DrawTimer_timeout():
	update()


# player 없음으로 기록
func set_no_player():
	in_eye = false
	in_attack = false
	in_dangerous = false
	
# player를 찾아서 현재 상태를 기록한다.
func _on_PlayerDetectionTimer_timeout():
	set_no_player()
	var players = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return
	
	var player:Node2D = players[0]
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
