extends TextureRect

export (NodePath) var player
onready var player_node : Player = get_node(player)
var sec = 0.75
var pressed_position
var disabled

func _ready():
	disabled = false
	
func _on_DashButton_pressed():
	if player_node != null:
		player_node.dash()
	disabled = true
	$Icon.self_modulate.a = 0.5
	$Tween.interpolate_property($TextureProgress, "value", 0, 100, sec, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
		

# tween이 끝나면 다시 클릭할수 있게 한다.
func _on_Tween_tween_completed(_object, _key):
	disabled = false
	$Icon.self_modulate.a = 1


func _on_DashButton_gui_input(event):
	if event is InputEventScreenTouch and event.pressed or event is InputEventMouseButton and event.is_pressed():
		if disabled:
			return
		Util.blank_light($Light2D, $TweenBlink)
		_on_DashButton_pressed()
