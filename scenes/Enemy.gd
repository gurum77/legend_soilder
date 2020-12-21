extends Node2D

export var HP = 3000



# Called when the node enters the scene tree for the first time.
func _ready():
	$HPBar.init(HP)
	
# damage 를 준다.
func damage(power):
	HP = HP - power
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()

func die():
	# dia animation 실행
	$Body/AnimatedSprites/BodyAnimatedSprite.play("die")
	$Body/AnimatedSprites/LegAnimatedSprite.visible = false
	$Body.stop_aim()
	$Body.stop_fire()
	
	# 모든 총돌 해제
	$Body/CollisionShape2D.queue_free()
	# 3초뒤 삭제
	yield(get_tree().create_timer(3), "timeout")
	call_deferred("queue_free")
	
