extends Area2D

var speed = 500
var power = 400
var player:bool = false
var free_after_animation = false

export (Define.Weapon) var weapon

# 화면을 벗어나면 삭제
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _ready():
	# layer / mask
	collision_layer = 0b100
	collision_mask = 0b10011
	
	# 무기종류에 맞는 animation을 실행
	var animation_name = Define.get_weapon_name(weapon)
	$AnimatedSprite.play(animation_name)
	
	# 무기 종류에 맞는 소리 실행
	$AudioStreamPlayer2D.stream = SoundManager.get_bullet_shot_audio_stream(weapon)
	$AudioStreamPlayer2D.play()
		
	
# bullet이 날아가도록 한다
func _physics_process(delta):
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)


func _on_Bullet_body_entered(body):
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
	
	# 어디든 부딪히면 총알은 터진	
	explosion()
	
# bullet을 폭파 시킨다.s
func explosion():
	free_after_animation = true
	if weapon == Define.Weapon.RPG:
		$AnimatedSprite.play("middle_explosion")
	else:
		$AnimatedSprite.play("small_explosion")
	speed = 0
	
	


func _on_AnimatedSprite_animation_finished():
	if free_after_animation:
		call_deferred("queue_free")
