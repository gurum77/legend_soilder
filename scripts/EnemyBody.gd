extends KinematicBody2D

class_name EnemyBody

export (Define.Weapon) var weapon
export var vehicle = false
export var bullet_nums = 1 # 총알 발사 개수
export var speed = 50

var weight = 0.3
var target_position_to_fire:Vector2 # 발사 목표 지점
var target_position_to_move:Vector2 # 이동 목표 지점
var velocity:Vector2
var dead = false # 죽었는지?

onready var fire_animated_sprite = get_node_or_null("AnimatedSprites/BodyPivot/FireAnimatedSprite")
onready var body_animated_sprite = $AnimatedSprites/BodyPivot/BodyAnimatedSprite
onready var leg_animated_sprite = $AnimatedSprites/LegAnimatedSprite
onready var fire_position = $AnimatedSprites/BodyPivot/FirePosition
onready var fire_position2 = get_node_or_null("AnimatedSprites/BodyPivot/FirePosition2")
onready var body_pivot = $AnimatedSprites/BodyPivot
onready var fire_timer = $FireTimer
onready var aim_timer = $AimTimer

func _ready():
	# layer/mask
	collision_layer = 0b10
	collision_mask	= 0b11011

	# 이동 목표지점을 제자리로 한다.
	target_position_to_move = self.global_position
	
	# connect
	fire_timer.connect("timeout", self, "_on_FireTimer_timeout")
	aim_timer.connect("timeout", self, "_on_AimTimer_timeout")
	body_animated_sprite.connect("animation_finished", self, "_on_BodyAnimatedSprite_animation_finished")
	if not fire_animated_sprite == null:
		fire_animated_sprite.connect("animation_finished", self, "_on_FireAnimatedSprite_animation_finished")

	start_aim()
	start_fire()


func _physics_process(delta):
	move_to_target()
	play_animation_by_velocity(velocity)
	turn_to_target()
	
	

# veloity에 따라 player의 animation을 한다.
func play_animation_by_velocity(velocity):
	if dead:
		return
		
	# leg animation
	# walk
	if velocity.length() > 0.5:
		leg_animated_sprite.play("walk")
	# idle
	else:
		leg_animated_sprite.play("idle")	
			
# 목표 지점으로 이동
func move_to_target():
	# die상태이면 이동하지 않는다
	if dead:
		return
		
	# 목표 지점 근처까지 오면 더이상 이동하지 않는다.
	if target_position_to_move.distance_to(self.global_position) < 10:
		return
		
	# velocity 결정
	velocity = (target_position_to_move - self.global_position).normalized() * speed
	
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
	

	
# target을 향해서 회전
func turn_to_target():
	if dead:
		return
	if target_position_to_fire == null:
		return
	# vehicle은 이동 방향에 따라서 전체를 회전하고 target position to fire를 향해서 body를 회전한다
	if vehicle == true:
		self.rotation = lerp_angle(self.rotation, (target_position_to_move - self.global_position).normalized().angle(), weight/10)
		body_pivot.rotation = lerp_angle(body_pivot.rotation, (target_position_to_fire - body_pivot.global_position).normalized().angle() - self.rotation, weight)
	else:
		self.rotation = lerp_angle(self.rotation, (target_position_to_fire - self.global_position).normalized().angle(), weight)

func get_fire_interval()->float:
	return 0.5
func get_aim_interval()->float:
	return 0.5
	
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

# fire		
func fire():
	for i in range(bullet_nums):
		var ins = Preloader.bullet.instance()
		var fire_position_node = fire_position
		if i == 1 && not fire_position2 == null:
			fire_position_node = fire_position2
		ins.position = fire_position_node.global_position
		ins.visible = true
		if weapon == null:
			ins.weapon = Define.Weapon.Pistol
		else:
			ins.weapon = weapon
		get_tree().root.call_deferred("add_child", ins)
		if vehicle == true:
			ins.rotation = self.rotation + body_pivot.rotation
		else:
			ins.rotation = rotation
	
	# body animation
	if body_animated_sprite != null:
		body_animated_sprite.frame = 0
		body_animated_sprite.play("fire")
	
	# fire animation
	if fire_animated_sprite != null:
		fire_animated_sprite.frame = 0
		fire_animated_sprite.visible = true
		fire_animated_sprite.play("fire")
	
# aim을 한다.
# 발사 목표 점을 찾는다.
func aim():
	# player를 찾는다.
	var players = get_tree().get_nodes_in_group("player")
	if players == null or players.size() == 0:
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
	body_animated_sprite.play("die")
	leg_animated_sprite.play("die")
	stop_aim()
	stop_fire()
	
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
		body_animated_sprite.play("idle")
