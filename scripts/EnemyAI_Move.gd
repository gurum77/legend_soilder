extends Node2D

# export var
onready var enemy_ai:EnemyAI = get_parent()
onready var patrol_path = $PatrolPath
onready var patrol_path_follow = $PatrolPath/PathFollow2D
export var path_offset = 50
var target_position:Vector2

# enemy의 moving 상태
enum {patrol, move, avoid}
var state = patrol

func start_patrol():
	state = patrol
	if patrol_path != null:
		patrol_path.fix_global_position = global_position
		
func start_move():
	state = move
	
func start_avoid():
	state = avoid
		
func _ready():
	start_patrol()
	
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
	# 시야에 들어오면 move 상태로 전환
	if enemy_ai.in_eye:
		start_move()
		
	# 공격 범위 안에 있으면 더이상 move하지 않고 avoid 상태로 전환한다.
	if enemy_ai.in_attack:
		start_avoid()

# 목표 위치를 찾는다.
# 목표 위치는 상태에 따라 다르다.
# move 중일때는 player를 목표 위치로 한다.
# patrol 일때는 patrol path를 따라 움직인다.
# avoid 일때는 avoid path를 따라 움직인다.
func _on_FindTargetTimer_timeout():
	match state:
		patrol:
			if patrol_path_follow != null:
				patrol_path_follow.offset += path_offset
				if patrol_path_follow.unit_offset >= 1:
					patrol_path_follow.unit_offset = 0
				enemy_ai.enemy.get_body().target_position_to_move = patrol_path_follow.global_position
		move:
			var player = enemy_ai.find_player()
			# player를 못 찾으면 목표지점을 자신으로 한
			if player == null:
				enemy_ai.enemy.get_body().target_position_to_move = self.global_position
				return
				
			enemy_ai.enemy.get_body().target_position_to_move = player.global_position
		avoid:
			pass
	
