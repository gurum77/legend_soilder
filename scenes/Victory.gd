extends Panel


func _on_HomeButton_pressed():
	get_tree().change_scene("res://scenes/Home.tscn")


func _on_NextButton_pressed():
	get_tree().change_scene("res://scenes/World.tscn")
