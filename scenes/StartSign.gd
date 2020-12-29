extends Control

func _ready():
	$Label.rect_size
	$Tween.interpolate_property($Label, "rect_scale", Vector2(0.1, 0.1), Vector2(1, 1), 1, Tween.TRANS_ELASTIC)
	$Tween.interpolate_property($Label, "rect_scale", Vector2(1, 1), Vector2(0.01, 0.01), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN, 1)
	$Tween.interpolate_property($Label, "visible", true, false, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN, 1.5)
	
	$Tween.start()

# tween이 끝나면 게임을 시작한다
func _on_Tween_tween_all_completed():
	StaticData.game_state = Define.GameState.play
