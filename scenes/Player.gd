extends KinematicBody2D

var bullet = preload("res://scenes/Bullet.tscn")

var velocity = Vector2(0, 0)
const SPEED = 150
export (NodePath) var move_joystick
onready var move_joystick_node : Joystick = get_node(move_joystick)
export (NodePath) var aim_joystick
onready var aim_joystick_node : Joystick = get_node(aim_joystick)
var fire_position_node
enum {idle, walking, Die, Fire}
var playing_body_animation_for_fire = false

func _ready():
	$AudioStreamPlayer2D.play()
	
func _physics_process(delta):
	# 이동 / 애니메이션 처리
	move_and_animation(delta)
	
	# fire
	if not aim_joystick_node == null and aim_joystick_node._touch_index > -1:
		start_fire()
	else:
		stop_fire()

# 발사를 시작한다
func start_fire():
	if $FireTimer.is_stopped() == true:
		fire()
		$FireTimer.start(get_fire_interval())

# 발사를 중지한다.
func stop_fire():
	if $FireTimer.is_stopped() == false:
		$FireTimer.stop()
	
		
# 무기 발사 interval(sec)
func get_fire_interval():
	return 0.2
	
# 이동 방향에 맞게 회전
# aim이 없으면 이동 방향에 따라 회전하고,
# aim이 있으면 aim 방향으로 회전한다.
func rotate_by_velocity(velocity):
	if not aim_joystick_node == null and aim_joystick_node.is_working:
		self.look_at(position + aim_joystick_node.output)
	else:
		self.look_at(position + velocity)
	
# 이동 / 애니메이션 처리를 한다.
func move_and_animation(delta):
	# velocity를 받아 온다.
	input_velocity_player()
	
	# 이동 속도에 따른 animation sprite 설정
	play_animation_by_velocity(velocity)
	
	# 이동 방향에 따라 player 회전
	rotate_by_velocity(velocity)
	
	# 이동	
	velocity = move_and_slide(velocity)
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y = lerp(velocity.y, 0, 0.2)
	
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
		$LegAnimatedSprite.play("walk")
		$AudioStreamPlayer2D.stream_paused = false
	# idle
	else:
		$LegAnimatedSprite.play("idle")	
		$AudioStreamPlayer2D.stream_paused = true
		
	# body animation
	if playing_body_animation_for_fire == false:
		$BodyAnimatedSprite.play(get_body_animation_name_header())

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
		
func fire():
	var ins = bullet.instance()
	ins.position = get_fire_position_node().global_position
	ins.visible = true
	ins.weapon = StaticData.get_current_inventory_item().weapon
	get_tree().root.add_child(ins)
	ins.rotation = rotation
	
	# body animation
	$BodyAnimatedSprite.play(get_body_animation_name_header()+ "_fire")
	playing_body_animation_for_fire = true
	
	# fire animation
	$FireAnimatedSprite.position = get_fire_position_node().position
	$FireAnimatedSprite.visible = true
	$FireAnimatedSprite.play(get_body_animation_name_header())
	
	
	
func _on_FireTimer_timeout():
	fire()

func _on_FireAnimatedSprite_animation_finished():
	$FireAnimatedSprite.visible = false

func _on_BodyAnimatedSprite_animation_finished():
	playing_body_animation_for_fire = false
