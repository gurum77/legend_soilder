extends KinematicBody2D

export var HP = 3000
var bullet = preload("res://scenes/Bullet.tscn")
var target_position:Vector2
var weight = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	$HPBar.init(HP)
	start_aim()
	start_fire()
	
func _physics_process(delta):
	turn_to_target()
	
# target을 향해서 회전
func turn_to_target():
	if target_position == null:
		return
	self.rotation = lerp_angle(self.rotation, (target_position - self.global_position).normalized().angle(), weight)

func get_fire_interval()->float:
	return 0.5
func get_aim_interval()->float:
	return 1.0
	
# 발사를 시작한다
func start_fire():
	if $FireTimer.is_stopped() == true:
		fire()
		$FireTimer.start(get_fire_interval())

# 발사를 중지한다.
func stop_fire():
	if $FireTimer.is_stopped() == false:
		$FireTimer.stop()

# aim을 시작한다.
func start_aim():
	if $AimTimer.is_stopped() == true:
		aim()
		$AimTimer.start(get_aim_interval())
		
# aim을 중지한다.
func stop_aim():
	if $AimTimer.is_stopped() == false:
		$AimTimer.stop()

# fire		
func fire():
	var ins = bullet.instance()
	ins.position = $FirePosition.global_position
	ins.visible = true
	ins.weapon = Define.Weapon.Pistol
	get_tree().root.add_child(ins)
	ins.rotation = rotation
	
	# body animation
	$AnimatedSprites/BodyAnimatedSprite.play("fire")
	
# aim을 한다.
func aim():
	# player를 찾는다.
	var players = get_tree().get_nodes_in_group("player")
	if players == null or players.size() == 0:
		return
	target_position = players[0].position

# damage 를 준다.
func damage(power):
	HP = HP - power
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()
	

func die():
	# dia animation 실행
	$AnimatedSprites/BodyAnimatedSprite.play("die")
	$AnimatedSprites/LegAnimatedSprite.visible = false
	# 모든 총돌 해제
	$CollisionShape2D.visible = false
	# 3초뒤 삭제
	yield(get_tree().create_timer(3), "timeout")
	call_deferred("queue_free")
	
	
func _on_FireTimer_timeout():
	fire()


func _on_AimTimer_timeout():
	aim()
