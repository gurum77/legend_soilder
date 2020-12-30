extends KinematicBody2D

class_name PlayerBody

var velocity = Vector2(0, 0)
const SPEED = 150
export (NodePath) var move_joystick
onready var move_joystick_node : Joystick = get_node_or_null(move_joystick)

export (NodePath) var aim_joystick
onready var aim_joystick_node : Joystick = get_node(aim_joystick)
var fire_position_node
var playing_body_animation_for_fire = false
var target_position:Vector2
enum {idle, walking, Die, Fire}

func get_velocity()->Vector2:
	return velocity
	
# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	target_position = self.global_position

func _physics_process(delta):
	# 게임중이 아니라면 이동을 하지 않는다
	if StaticData.game_state != Define.GameState.play:
		return
		
	# 이동처리
	move(delta)
	
	# 이동 속도에 따른 animation sprite 설정
	play_animation_by_velocity(get_velocity())
	
	# 이동 방향에 따라 player 회전
	rotate_by_velocity(get_velocity())
	
	# fire
	if not aim_joystick_node == null and aim_joystick_node._touch_index > -1:
		start_fire()
	else:
		stop_fire()
		
		
# 무기 발사 interval(sec)
func get_fire_interval():
	return 0.2
	
# 발사를 시작한다
func start_fire():
	if $FireTimer.is_stopped() == true:
		fire()
		$FireTimer.start(get_fire_interval())

# 발사를 중지한다.
func stop_fire():
	if $FireTimer.is_stopped() == false:
		$FireTimer.stop()
	
		
# 이동 방향에 맞게 회전
# aim이 없고 터치도 없으면 이동 방향에 따라 회전하고,
# aim이 없고 터치만 있으면 지정된 목표위치를 향해서 회전한다
# aim이 있으면 aim 방향으로 회전한다.
func rotate_by_velocity(velocity):
	# aim joystick을 터치중인 경우
	if not aim_joystick_node == null and aim_joystick_node._touch_index > -1:
		# aim joystick을 drag중인 경우 joystick 방향으로 바라 본다.
		if aim_joystick_node.is_working:
			self.look_at(global_position + aim_joystick_node.output)
		# aim joystick을 drag하지 않은 경우 target position 방향을 바라 본다
		else:
			self.look_at(target_position)
	# aim joystick을 터치하지 않고 있는 경우
	else:
		self.look_at(global_position + velocity)
		
func _on_FireTimer_timeout():
	fire()

func _on_FireAnimatedSprite_animation_finished():
	$AnimatedSprites/FireAnimatedSprite.visible = false

func _on_BodyAnimatedSprite_animation_finished():
	playing_body_animation_for_fire = false		

func fire():
	var ins = Preloader.bullet.instance()
	ins.position = get_fire_position_node().global_position
	ins.visible = true
	ins.player = true
	ins.weapon = StaticData.get_current_inventory_item().weapon
	get_tree().root.add_child(ins)
	ins.rotation = rotation
	
	# body animation
	$AnimatedSprites/BodyAnimatedSprite.play(get_body_animation_name_header()+ "_fire")
	playing_body_animation_for_fire = true
	
	# fire animation
	$AnimatedSprites/FireAnimatedSprite.position = get_fire_position_node().position
	$AnimatedSprites/FireAnimatedSprite.visible = true
	$AnimatedSprites/FireAnimatedSprite.play(get_body_animation_name_header())
	
	
# 무기에 따른 body animation의 이름
func get_body_animation_name_header() -> String:
	var item = StaticData.get_current_inventory_item()
	if item == null:
		return "None"
		
	return Define.get_weapon_name(item.weapon)
		

# veloity에 따라 player의 animation을 한다.
func play_animation_by_velocity(velocity):
	# leg animation
	# walk
	if velocity.length() > 0.5:
		$AnimatedSprites/LegAnimatedSprite.play("walk")
		$AudioStreamPlayer2D.stream_paused = false
	# idle
	else:
		$AnimatedSprites/LegAnimatedSprite.play("idle")	
		$AudioStreamPlayer2D.stream_paused = true
		
	# body animation
	if playing_body_animation_for_fire == false:
		$AnimatedSprites/BodyAnimatedSprite.play(get_body_animation_name_header())

func get_fire_position_node() -> Node:
	if StaticData.get_current_inventory_item().weapon == Define.Weapon.Pistol:
		return $PistolFirePosition
	elif StaticData.get_current_inventory_item().weapon == Define.Weapon.FlameThrower:
		return $FlameThrowerFirePosition
	elif StaticData.get_current_inventory_item().weapon == Define.Weapon.MG:
		return $MGFirePosition
	elif StaticData.get_current_inventory_item().weapon == Define.Weapon.RPG:
		return $RPGFirePosition
	elif StaticData.get_current_inventory_item().weapon == Define.Weapon.SMG:
		return $SMGFirePosition
		
	return self	


# 조이스틱을 누르고만 있다면 자동으로 가장 가까운 적을 조준한다.
func _on_AimTimer_timeout():
	if aim_joystick_node == null:
		return
	if aim_joystick_node._touch_index < 0:
		return

	# 가까운 적을 찾는다.
	var enemy = find_nearest_enemy()
	if enemy == null:
		target_position = self.global_position + get_velocity() * 100
	else:
		target_position = enemy.global_position
		
func find_nearest_enemy()->Node2D:
	var minimum_distance = INF
	var nearest_enemy
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		# hp가 없는 적은 통과
		if enemy.HP <= 0:
			continue
		var distance = enemy.global_position.distance_to(self.global_position)
		if distance < minimum_distance:
			minimum_distance = distance
			nearest_enemy = enemy
			
	return nearest_enemy
	
	
	
# 이동 처리를 하고 velocity를 계산한
func move(delta):
	# velocity를 받아 온다.
	input_velocity_player()
	
	if velocity == Vector2(0, 0):
		return

	# 이동 전에 자신의 상대위치를 기억한다.
	var position_old = self.position
		
	# 이동	
	velocity = move_and_slide(velocity)
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y = lerp(velocity.y, 0, 0.2)
	
	# 이동을 하고 나면 이동 된 위치로 부모를 이동시키고, 
	# 자신의 부모기준 상대위치를 복구시킨다.
	get_parent().global_position = self.global_position
	self.position = position_old
	
# player 입력을 받는다
func input_velocity_player():
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	if Input.is_action_pressed("ui_up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
	elif not move_joystick_node == null and move_joystick_node.is_working:
		velocity = move_joystick_node.output.normalized() * SPEED
