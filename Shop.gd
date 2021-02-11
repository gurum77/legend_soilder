extends Panel

func _on_BackButton_pressed():
	var err = get_tree().change_scene("res://scenes/Home.tscn")
	if err != OK:
		push_error("change_scene failed")
