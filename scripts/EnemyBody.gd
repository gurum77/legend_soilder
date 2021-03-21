extends KinematicBody2D

class_name EnemyBody
enum EnemyType{normal, vehicle, airplane}
export (Define.Weapon) var weapon
export var bullet_nums = 1 # 총알 발사 개수
export var speed = 50
export (float) var fire_interval = 1.0	# 총알 발사 간격
export (float) var aim_interval = 0.5	# 조준 간격
export (int) var fire_nums_to_rest = 10	# 몇 번 발사후 쉬는지?
export (EnemyType) var enemy_type = EnemyType.normal

var weight = 0.3
var target_position_to_fire:Vector2 # 발사 목표 지점
var target_position_to_move:Vector2 # 이동 목표 지점
var target_position_buffer_to_move:= PoolVector2Array() # 이동 지점에 도달하면 여기서 하나씩 꺼내서 이동 목표 지점을 설정한다
var velocity:Vector2
var dead = false # 죽었는지?
var rayCast
var fixed_rotation = false	# 방향이 정해짐
var target_position_to_move_to_fixed_rotation:Vector2 # 방향이 고정됐을때의 target_position
var fire_started = false	# fire를  시작했는지?
var current_fire_nums_to_rest = 0	# 쉬기 위해서 현재까지 몇번 발사를 했는지?

onready var body_animated_sprite = $AnimatedSprites/BodyPivot/BodyAnimatedSprite
onready var leg_animated_sprite = $AnimatedSprites/LegAnimatedSprite
onready var fire_animated_sprite = get_node_or_null("AnimatedSprites/BodyPivot/FireAnimatedSprite")
onready var fire_animated_sprite2 = get_node_or_null("AnimatedSprites/BodyPivot/FireAnimatedSprite2")
onready var fire_animated_sprite3 = get_node_or_null("AnimatedSprites/BodyPivot/FireAnimatedSprite3")
onready var fire_animated_sprite4 = get_node_or_null("AnimatedSprites/BodyPivot/FireAnimatedSprite4")
onready var fire_position = $AnimatedSprites/BodyPivot/FirePosition
onready var fire_position2 = get_node_or_null("AnimatedSprites/BodyPivot/FirePosition2")
onready var fire_position3 = get_node_or_null("AnimatedSprites/BodyPivot/FirePosition3")
onready var fire_position4 = get_node_or_null("AnimatedSprites/BodyPivot/FirePosition4")
onready var body_pivot = $AnimatedSprites/BodyPivot
onready var fire_timer = $FireTimer
onready var aim_timer = $AimTimer
onready var foot_step_audio = get_node_or_null("FootStepAudio")
onready var die_audio = get_node_or_null("DieAudio")
onready var enemy_ai = get_parent().get_node_or_null("EnemyAI")

func _ready():
	# layer/mask
	if enemy_type == EnemyType.airplane:
		collision_layer = 0b100000000
		collision_mask	= 0b00100	# airplane인 경우에는 총알말고 어디에도 부딪히지 않는
		z_index = Util.AIRPLANE_NODE_Z_INDEX
	else:
		collision_layer = 0b10
		collision_mask	= 0b10100
	
	

	# 이동 목표지점을 제자리로 한다.
	target_position_to_move = self.global_position
	
	# connect
	fire_timer.connect("timeout", self, "_on_FireTimer_timeout")
	aim_timer.connect("timeout", self, "_on_AimTimer_timeout")
	body_animated_sprite.connect("animation_finished", self, "_on_BodyAnimatedSprite_animation_finished")
	if not fire_animated_sprite == null:
		fire_animated_sprite.connect("animation_finished", self, "_on_FireAnimatedSprite_animation_finished")

	# 시작할땐 idle로 시작하도록 해야함
	Util.play_animation(body_animated_sprite, "idle")
	Util.play_animation(fire_animated_sprite, "idle")
	
	start_aim()
	


func _physics_process(_delta):
	move_to_target()
	play_animation_by_velocity(velocity)
	turn_to_target()
	if !fire_started:
		fire_started = true
		# 처음 발사를 랜덤하게 시작한다.
		yield(get_tree().create_timer(randf()), "timeout")
		start_fire()	
	
	

# veloity에 따라 player의 animation을 한다.
func play_animation_by_velocity(_velocity):
	if dead:
		return
		
	# leg animation
	# walk
	if _velocity.length() > 0.5:
		Util.play_animation(leg_animated_sprite, "walk")
		if foot_step_audio != null:
			if !foot_step_audio.playing:
				foot_step_audio.play()
			foot_step_audio.stream_paused = false
	# idle
	else:
		Util.play_animation(leg_animated_sprite, "idle")	
		if foot_step_audio != null:
			foot_step_audio.stream_paused = false
	
# 이동 목표 지점에 도달했는지?		
func arrived_in_target_position_to_move()->bool:
	var dist = target_position_to_move.distance_to(self.global_position)
	if dist < speed / 100.0:
		return true
	return false
	
# 목표 지점으로 이동
func move_to_target():
	# 게임중이 아니라면 이동하지 않는다.
	if StaticData.game_state != Define.GameState.play:
		return
		
	# die상태이면 이동하지 않는다
	if dead:
		return
		
	# 목표 지점 근처까지 오면 buffer에서 target을 가져오거나 
	# buffer가 없으면 더이상 이동 하지 않는다.
	if arrived_in_target_position_to_move():
		for i in target_position_buffer_to_move.size():
			if target_position_buffer_to_move[i] == target_position_to_move:
				target_position_buffer_to_move.remove(0)
				i -= 1
				continue
			target_position_to_move = target_position_buffer_to_move[0]
			target_position_buffer_to_move.remove(0)
			break
		return
		
	# velocity 결정
	# airplane은 진행방향으로만 이동이 가능하다(후진 불가)
	if enemy_type == EnemyType.airplane && !fixed_rotation:
		var xdir = Vector2(cos(self.rotation), sin(self.rotation))
		velocity = xdir * speed
	else:
		velocity = (target_position_to_move - self.global_position).normalized() * speed
	
	if velocity == Vector2(0, 0):
		return
	
	move_by_velocity(velocity)

func move_by_velocity(v):
	# 이동 전에 자신의 상대위치를 기억한다.
	var position_old = self.position
		
	# 이동	
	velocity = move_and_slide(v)
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y = lerp(velocity.y, 0, 0.2)
	
	# 이동을 하고 나면 이동 된 위치로 부모를 이동시키고, 
	# 자신의 부모기준 상대위치를 복구시킨다.
	get_parent().global_position = self.global_position
	self.position = position_old
	
# target을 향해서 회전
func turn_to_target():
	if dead:
		return
	if target_position_to_fire == null:
		return
	# vehicle은 이동 방향에 따라서 전체를 회전하고 target position to fire를 향해서 body를 회전한다
	if enemy_type == EnemyType.vehicle:
		self.rotation = lerp_angle(self.rotation, (target_position_to_move - self.global_position).normalized().angle(), weight/10)
		body_pivot.rotation = lerp_angle(body_pivot.rotation, (target_position_to_fire - body_pivot.global_position).normalized().angle() - self.rotation, weight)
	elif enemy_type == EnemyType.airplane:
		if !fixed_rotation:
			var target_rotation = (target_position_to_move - self.global_position).normalized().angle()
			self.rotation = lerp_angle(self.rotation, target_rotation, weight/10)
			# 목표한 방향에 도달하면 target_position_to_move가 변경될때까지 회전하지 않는
			if Util.is_equal_double(self.rotation, target_rotation, 0.1):
				fixed_rotation = true
				target_position_to_move_to_fixed_rotation = target_position_to_move
		else:
			# target_position_to_move가 변경되면 fixed rotation을 푼다
			if !Util.is_equal_vector2(target_position_to_move, target_position_to_move_to_fixed_rotation, 1):
				fixed_rotation = false
				
	else:
		self.rotation = lerp_angle(self.rotation, (target_position_to_fire - self.global_position).normalized().angle(), weight)

func get_fire_interval()->float:
	return fire_interval
func get_aim_interval()->float:
	return aim_interval
	
# 발사를 시작한다
func start_fire():
	if fire_timer.is_stopped() == true:
		fire()
		fire_timer.start(get_fire_interval())

# 발사를 중지한다.
func stop_fire():
	if fire_timer.is_stopped() == false:
		fire_timer.stop()

# aim을 시작한다.
func start_aim():
	if aim_timer.is_stopped() == true:
		aim()
		aim_timer.start(get_aim_interval())
		
# aim을 중지한다.
func stop_aim():
	if aim_timer.is_stopped() == false:
		aim_timer.stop()

func get_fire_animated_sprite(var bullet_index)->AnimatedSprite:
	var fas = fire_animated_sprite
	if bullet_index == 1:
		fas = fire_animated_sprite2
	elif bullet_index == 2:
		fas = fire_animated_sprite3
	elif bullet_index == 3:
		fas = fire_animated_sprite4
	return fas
	
func get_fire_position_node(var bullet_index)->Node2D:
	var fire_position_node = fire_position;
	if bullet_index == 1 && fire_position2 != null:
		fire_position_node = fire_position2
	elif bullet_index == 2 && fire_position3 != null:
		fire_position_node = fire_position3
	elif bullet_index == 3 && fire_position4 != null:
		fire_position_node = fire_position4
	return fire_position_node

# 발사를 쉬는 중인지?
func is_rest_to_fire():
	return current_fire_nums_to_rest >= fire_nums_to_rest	
	
# fire		
func fire():
	if is_rest_to_fire():
		return
		
	if Define.no_attack_enemy:
		return
		
	if StaticData.game_state != Define.GameState.play:
		return
		
	# enemy의 상태가 공격범위 상태가 아니라면 발사하지 않는다.
	if enemy_ai != null && !enemy_ai.in_attack:
		return
	
	
		
	# body animation
	Util.play_animation(body_animated_sprite, "fire")

	for i in range(bullet_nums):
		# bullet 생성
		var ins = Preloader.bullet.instance()
		var fire_position_node = get_fire_position_node(i)
		
		if fire_position_node == null:
			assert(false)
			continue
			
		ins.position = fire_position_node.global_position
		ins.visible = true
		# 두번째 부터는 묵음처리
		if i > 0:
			ins.mute = true
		if weapon == null:
			ins.weapon = Define.Weapon.Pistol
		else:
			ins.weapon = weapon
		get_tree().root.call_deferred("add_child", ins)
		if enemy_type == EnemyType.vehicle:
			ins.rotation = self.rotation + body_pivot.rotation
		else:
			ins.rotation = rotation
			
		# fire animation
		var fas = get_fire_animated_sprite(i)
		Util.play_animation(fas, "fire", true)

	# 쉬기까지의 발사 횟수를 증가시킨다.
	current_fire_nums_to_rest += 1
	
	# 쉬어야 하면 3초를 쉰
	if is_rest_to_fire():
		# 3초를 쉬고 발사횟수를 초기화 한다.
		yield(get_tree().create_timer(3), "timeout")
		current_fire_nums_to_rest = 0
	
	
# aim을 한다.
# 발사 목표 점을 찾는다.
func aim():
	# 비행기는 무조건 진행방향으로만 aim을 한다
	if enemy_type == EnemyType.airplane:
		target_position_to_fire = global_position + velocity * 10
	else:
		# player를 찾는다.
		var players = get_tree().get_nodes_in_group("player")
		if players == null or players.size() == 0:
			return
		
		# target이 없다면 진행방향으로 aim을 한다.
		if enemy_ai == null || !enemy_ai.in_eye:
			target_position_to_fire = global_position + velocity * 10
			return
			
		target_position_to_fire = players[0].position


func _on_FireTimer_timeout():
	fire()

func _on_AimTimer_timeout():
	aim()

# die 처리를 한
func die():
	dead = true
	
	# dia animation 실행
	Util.play_animation(body_animated_sprite, "die")
	Util.play_animation(leg_animated_sprite, "die")
	stop_aim()
	stop_fire()
	
	# sound
	if die_audio != null:
		die_audio.play()
	
	# 모든 총돌 해제
	$CollisionShape2D.queue_free()

# fire animation은 한번 쏘면 사라진다.
# 다음에 쏠때 다시 보여준다.
func _on_FireAnimatedSprite_animation_finished():
	if fire_animated_sprite != null:
		fire_animated_sprite.visible = false


# body animation은 죽지 않은 경우 animation finish 후에 항상 idle로 바꿔준다.
func _on_BodyAnimatedSprite_animation_finished():
	if not dead:
		Util.play_animation(body_animated_sprite, "idle")
