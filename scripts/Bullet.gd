extends Area2D


var distance = 100	# 사거리
var speed = 500
var power = 400
var player:bool = false
var free_after_animation = false
var start_position 
var hit_object:Dictionary

export (Define.Weapon) var weapon

# 화면을 벗어나면 삭제
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _ready():
	# layer / mask
	collision_layer = 0b100
	collision_mask = 0b10011
	
	# power
	power = Table.get_weapon_power_by_level(weapon)

	# 무기 종류에 맞는 사거리 결정
	distance = Table.get_weapon_bullet_distance(weapon)

	# 시작 위치 보관	
	start_position = position
	
	# 무기 종류에 맞는 animation을 실행
	var animation_name = Define.get_weapon_name(weapon)
	$AnimatedSprite.play(animation_name)
	
	# 무기 종류에 맞는 소리 실행
	$AudioStreamPlayer2D.stream = SoundManager.get_bullet_shot_audio_stream(weapon)
	$AudioStreamPlayer2D.play()
		
	
# bullet이 날아가도록 한다
func _physics_process(delta):
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)
	# 사거리가 지정된 경우 사거리 이상 날아가면 폭파
	if distance > 0 and position.distance_to(start_position) > distance:
		explosion()


func _on_Bullet_body_entered(body):
	# 한번 맞으면 더이상 맞지 않도록 한다.
	if hit_object.has(body) == true:
		return
	hit_object[body] = true
	
	# 같은 편이면 리턴
	# 건물은 편이 없으므로 그냥 총알을 터트린다.
	if player and body is PlayerBody:
		return
	if not player and body is EnemyBody:
		return
		
	# player나 enemy이면 damage를 준다
	if body is PlayerBody or body is EnemyBody:
		body.get_parent().damage(power)
	elif body is ObstacleBody:
		body.get_parent().damage(power)
	# push
	push_body(body)
	
	# 어디든 부딪히면 총알은 터진다
	explosion()
	
func push_body(body):
	if body is EnemyBody:
		var push_power = power / 3
		if push_power > 3000:
			push_power = 3000
		var push_velocity = Vector2(cos(rotation), sin(rotation)) * push_power
		body.move_by_velocity(push_velocity)
		
# bullet을 폭파 시킨다.
func explosion():
	# animation이 끝나면 제거한다.
	free_after_animation = true
	
	# 폭파 animation 실행
	if weapon == Define.Weapon.RPG:
		$AnimatedSprite.play("middle_explosion")
	else:
		$AnimatedSprite.play("small_explosion")
	speed = 0
	
	


func _on_AnimatedSprite_animation_finished():
	if free_after_animation:
		call_deferred("queue_free")
