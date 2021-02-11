extends Control



func _on_BackButton_pressed():
	var err = get_tree().change_scene("res://scenes/Home.tscn")
	if err != OK:
		push_error("change_scene failed")

# 빠져 나갈때 마다 저장한다
func _exit_tree():
	StaticData.save_game()
