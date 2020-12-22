extends KinematicBody2D

class_name EnemyBody

export (Define.Weapon) var weapon
export var vehicle = false
export var bullet_nums = 1 # 총알 발사 개수

var weight = 0.3
var target_position:Vector2
var dead = false # 죽었는지?

onready var fire_animated_sprite = get_node_or_null("AnimatedSprites/BodyPivot/FireAnimatedSprite")
onready var body_animated_sprite = $AnimatedSprites/BodyPivot/BodyAnimatedSprite
onready var leg_animated_sprite = $AnimatedSprites/LegAnimatedSprite
onready var fire_position = $AnimatedSprites/BodyPivot/FirePosition
onready var fire_position2 = $AnimatedSprites/BodyPivot/FirePosition2
onready var body_pivot = $AnimatedSprites/BodyPivot
onready var fire_timer = $FireTimer
onready var aim_timer = $AimTimer

func _ready():
	# connect
	fire_timer.connect("timeout", self, "_on_FireTimer_timeout")
	aim_timer.connect("timeout", self, "_on_AimTimer_timeout")
	body_animated_sprite.connect("animation_finished", self, "_on_BodyAnimatedSprite_animation_finished")
	if not fire_animated_sprite == null:
		fire_animated_sprite.connect("animation_finished", self, "_on_FireAnimatedSprite_animation_finished")


		
	start_aim()
	start_fire()


func _physics_process(delta):
	turn_to_target()
	
# target을 향해서 회전
func turn_to_target():
	if target_position == null:
		return
	if vehicle == true:
		body_pivot.rotation = lerp_angle(body_pivot.rotation, (target_position - body_pivot.global_position).normalized().angle(), weight)
	else:
		self.rotation = lerp_angle(self.rotation, (target_position - self.global_position).normalized().angle(), weight)

func get_fire_interval()->float:
	return 0.5
func get_aim_interval()->float:
	return 1.0
	
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
		get_tree().root.add_child(ins)
		if vehicle == true:
			ins.rotation = body_pivot.rotation
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
	target_position = players[0].position


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
