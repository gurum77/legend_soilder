extends Area2D


export var dist:float = 30
export var speed_per_sec:float = 130
export var running_time = 1.0

var water_tilemap:TileMap
# 점핑패드 안에 있는 노드들
var nodes_in_JumpingTrap:Dictionary
var running = false
var jumping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# water tilemap을 찾는다
	water_tilemap = find_water_tile_map(get_tree().root)
	$AnimatedSprite.stop()
	running = false
	nodes_in_JumpingTrap.clear()
	$Sprite.global_position = find_target_position()


# water tile map을 찾는다.
func find_water_tile_map(var cur_node)->TileMap:
	var nodes = cur_node.get_children()
	for node in nodes:
		if node is TileMap:
			return node as TileMap
		var tilemap = find_water_tile_map(node)
		if tilemap == null:
			continue
		if tilemap.get_collision_layer_bit(7):
			return tilemap
		
	return null
		
func _on_JumpingTrap_body_entered(body):
	# jump 중일때는 뭔가 들어와도 동작하지 않도록 한다
	if jumping == true:
		return
	# 점핑트랩 안에 들어온 노드 등록
	nodes_in_JumpingTrap[body] = body.collision_mask
	
	# 동작중이 아니라면 동작을 시작한다.
	if running == false:
		run()

# jumping pad 동작을 시작한다.
func run():
	$AnimatedSprite.play("run")
	# running 타임 동안 animation 돌다가 transforting 시작
	$RunningTimer.start(running_time)
	
	
# jumping trap에서 빠져 나가면 목록에서 지운다.
func _on_JumpingTrap_body_exited(body):
	nodes_in_JumpingTrap.erase(body)
	
# jump할 target 위치를 찾는다.
func find_target_position()->Vector2:
	var target_position:Vector2 = global_position + get_global_transform().x * dist
	
	# 여기는 최소 거리이다.
	# 여기서 부터 걸리는것이 없을때 까지 이동
	var raycasts = [$TargetRayCast2D1, $TargetRayCast2D2, $TargetRayCast2D3]
	
	var cur_dist = dist
	# 처음 거리부터 늘려가면서 체크한다.
	# 최대 30번 반복한다.
	var offset = 30
	var max_repeat = 32
	var found_target_position = false
	for i in max_repeat:
		cur_dist += offset
		for raycast in raycasts:
			var r:RayCast2D = raycast
			r.global_position = global_position + r.get_global_transform().x * cur_dist
			# raycast의 시작좌표가 water이면 검사가 안됨.
			if is_inside_water(r.global_position):
				continue
			r.force_raycast_update()
			if r.is_colliding():
				continue
			target_position = r.global_position
			found_target_position = true
			break
		if found_target_position:
			break
	return target_position
	
func jump_nodes():
	jumping = true
	$AnimatedSprite.stop()
	# jumping trap을 스케일을 키운다.
	$Tween.interpolate_property(self, "scale", scale, Vector2(1.5, 1.5), 0.05, Tween.TRANS_BOUNCE, Tween.EASE_IN) 
#	$Tween.interpolate_property(self, "scale", Vector2(1.5, 1.5), Vector2(1.2, 1.2), 0.3, Tween.TRANS_BOUNCE, Tween.EASE_IN, 0.1)
	$Tween.interpolate_property(self, "scale", Vector2(1.3, 1.3), Vector2(1.0, 1.0), 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.4)
	
	# 목적지 계산
	var target_position:Vector2 = find_target_position()
	var duration = dist / speed_per_sec
	
	for node in nodes_in_JumpingTrap:
		var target_node = null
		if node is PlayerBody:
			target_node = node.get_parent()
		elif node is EnemyBody:
			target_node = node.get_parent()
		
		if target_node == null:
			continue
			
		# 장애물에 가려지면 안되므로 z_index를 2로 설정
		var z_index_old = target_node.z_index
		var collision_mask_old = node.collision_mask
		var scale_old = Vector2(target_node.scale.x, target_node.scale.y)

		target_node.z_index = 2
		node.collision_mask = 0

		# jump 위치 이동
		$Tween.interpolate_property(target_node, "global_position", target_node.global_position, target_position, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		
		# z_index 복구
		$Tween.interpolate_property(target_node, "z_index", target_node.z_index, z_index_old, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN, duration)
		
		# collision mask 복구
		$Tween.interpolate_property(node, "collision_mask", node.collision_mask, collision_mask_old, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN, duration)
		
		# scale 변경 후 복구
		$Tween.interpolate_property(target_node, "scale", target_node.scale, Vector2(2, 2), duration/2.0, Tween.TRANS_SINE, Tween.EASE_IN)
		$Tween.interpolate_property(target_node, "scale", Vector2(2, 2), scale_old, duration/2.0, Tween.TRANS_SINE, Tween.EASE_IN, duration/2.0)
			
	$Tween.start()

# 좌표가 water안쪽인지?
func is_inside_water(var position)->bool:
	if water_tilemap == null:
		return false
	var map_position = water_tilemap.world_to_map(position)
	var c = water_tilemap.get_cellv(map_position)
	# tile id 0 이 물만 있는 tile이다. 다른 타일은 흙이 섥여 있으니 점프 가능하다(물 아닌 것으로 한다)
	if c == 0:
		return true
	return false
	
# running timer가 끝나면 위에 있는 노드들을 모두 점프시킨다.
func _on_RunningTimer_timeout():
	jump_nodes()
	$RunningTimer.stop()



# jump가 끝나야 동작이 완전히 끝난거다
func _on_Tween_tween_all_completed():
	running = false
	jumping = false
