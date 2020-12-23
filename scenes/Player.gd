extends KinematicBody2D

var velocity = Vector2(0, 0)
var HP = 30000
const SPEED = 150
export (NodePath) var move_joystick
onready var move_joystick_node : Joystick = get_node_or_null(move_joystick)


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
	$Body/AnimatedSprites/FireAnimatedSprite.visible = false
	
	# 모든 총돌 해제
	$Body/CollisionShape2D.queue_free()
	
		
func _physics_process(delta):
	# 이동처리
	move(delta)

	
# 이동 처리를 하고 velocity를 계산한
func move(delta):
	# velocity를 받아 온다.
	input_velocity_player()
	
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
