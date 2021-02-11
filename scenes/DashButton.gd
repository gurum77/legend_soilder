extends TextureButton

export (NodePath) var player
onready var player_node : Player = get_node(player)
var sec = 3
func _ready():
	disabled = false
	
func _on_DashButton_pressed():
	if player_node != null:
		if !player_node.dash():
			return
		disabled = true
		$Icon.self_modulate.a = 0.5
		$Tween.interpolate_property($TextureProgress, "value", 0, 100, sec, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		

# tween이 끝나면 다시 클릭할수 있게 한다.
func _on_Tween_tween_completed(_object, _key):
	disabled = false
	$Icon.self_modulate.a = 1
