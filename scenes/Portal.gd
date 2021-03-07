extends Area2D

var other_portal

enum PortalColor{red, green, blue, yellow}
var in_nodes:Dictionary		# 포탈에 들어온 노드
var out_nodes:Dictionary	# 포탈로 나온 노
var running = false	
var transforting = false
export (PortalColor) var portal_color
export var running_time = 1.0
export var transforting_time = 1.0


func get_portal_color(var running_color=false)->Color:
	var col = Color(1, 1, 1, 1)
	match portal_color:
		PortalColor.red:
			col = Color(1, 0, 0, 1)
		PortalColor.green:
			col = Color(0, 1, 0, 1)
		PortalColor.blue:
			col = Color(0, 0, 1, 1)
		PortalColor.yellow:
			col = Color(1, 1, 0, 1)
	if running_color:
		col.r = col.r * 1.3
		col.g = col.g * 1.3
		col.b = col.b * 1.3
	return col
			
	
func _ready():
	$Sprite.modulate = get_portal_color()
	$AudioStreamPlayer2D.stream.loop = false

func get_other_animated_sprite()->AnimatedSprite:
	 return other_portal.get_node_or_null("TransfortAnimatedSprite")

func _on_Portal_body_entered(body):
	# 동작중인 경우에 이쪽으로 나온 노드는 포탈안됨
	if running || transforting:
		if out_nodes.has(body):
			return
		
	in_nodes[body] = true
		
	# transforting중이면 transforting을 한다.
	if transforting:
		transfort()
		
	# 동작중이 아니라면 동작을 시작한다.
	if running == false:
		run()
		run_other()
		
func _on_Portal_body_exited(body):
	if in_nodes.has(body):
		in_nodes.erase(body)


func _on_RunningTimer_timeout():
	transforting = true
	$AnimatedSprite.speed_scale = 10
	$TransfortingTimer.start()
	transfort()

func _on_TransfortingTimer_timeout():
	running = false
	transforting = false
#	$AnimatedSprite.modulate = Color(1, 1, 1, 1)
	$Sprite.modulate = get_portal_color()
	$AnimatedSprite.stop()
	
func run_other():
	if other_portal == null:
		return
	other_portal.run()
	
func run():
	running = true
	$AnimatedSprite.play("run")
	$Tween.interpolate_property($AnimatedSprite, "speed_scale", 1, 5, running_time, Tween.TRANS_SINE, Tween.EASE_OUT)
#	$Tween.interpolate_property($AnimatedSprite, "modulate", Color(1, 1, 1, 1), Color(1.5, 1, 1, 1), running_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.interpolate_property($Sprite, "modulate", get_portal_color(), get_portal_color(true), running_time, Tween.TRANS_SINE, Tween.EASE_OUT)
	
	$Tween.start()

	# running 타임 동안 animation 돌다가 transforting 시작
	$RunningTimer.start(running_time)
		
# transfort를 한다.
func transfort():
	if other_portal == null:
		return
	
	$AudioStreamPlayer2D.play()
	
	var global_position = other_portal.global_position
	for node in in_nodes:
		other_portal.out_nodes[node] = true
		get_other_animated_sprite().visible = true
		get_other_animated_sprite().frame = 1
		get_other_animated_sprite().play("transfort")
		if node is PlayerBody:
			node.get_parent().global_position = global_position
		elif node is EnemyBody:
			node.get_parent().global_position = global_position
	in_nodes.clear()
		
	


func _on_TransfortAnimatedSprite_animation_finished():
	$TransfortAnimatedSprite.visible = false
	$TransfortAnimatedSprite.stop()


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.stop()
