extends Node2D
class_name EnemyAI_Move

# export var
onready var enemy_ai:EnemyAI = get_parent()
onready var patrol_path = $PatrolPath
onready var patrol_path_follow = $PatrolPath/PathFollow2D
export var path_offset = 50
var path_finder:PathFinder

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

func _physics_process(_delta):
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
			
			# target위치 계산	
			var target_position = player.global_position
			var target_position_buffer := PoolVector2Array()
			
			# path finder가 있으면 path finder로 경로를 찾는다.
			if path_finder != null:
				var point_path = path_finder.find_path(self.global_position, player.global_position)
				if point_path != null and point_path.size() > 3:
#					var current_point = path_finder.tilemap.world_to_map(global_position)
					# 겹치지 않게 하기 위해서 3~6 사이의 위치에 랜덤하게 배치한다.
					var index:int = rand_range(1, point_path.size()) as int
					for i in index-2:
						target_position_buffer.append(point_path[i+2])
					target_position = Vector2(point_path[1].x, point_path[1].y)
			
			enemy_ai.enemy.get_body().target_position_to_move = target_position
			enemy_ai.enemy.get_body().target_position_buffer_to_move = target_position_buffer
		avoid:
			pass
	
