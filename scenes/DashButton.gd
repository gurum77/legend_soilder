extends TextureButton

export (NodePath) var player
onready var player_node : Player = get_node(player)
var sec = 3
func _on_DashButton_pressed():
	if player_node != null:
		if !player_node.dash():
			return
		disabled = true
		$Icon.visible = false
		$Tween.interpolate_property(self, "self_modulate", Color(0.2, 0.2, 0.2, 1), self_modulate, sec, Tween.TRANS_QUART, Tween.EASE_IN)
		$Tween.start()
		

# tween이 끝나면 다시 클릭할수 있게 한다.
func _on_Tween_tween_completed(object, key):
	disabled = false
	$Icon.visible = true
