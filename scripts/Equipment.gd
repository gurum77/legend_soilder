extends Control



func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/Home.tscn")

# 빠져 나갈때 마다 저장한다
func _exit_tree():
	StaticData.save_game()
