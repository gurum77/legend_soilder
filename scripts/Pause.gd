extends Panel

var settings = preload("res://scenes/Settings.tscn")


func _on_SettingButton_pressed():
	get_tree().paused = false
	var ins = settings.instance()
	add_child(ins)


func _on_HomeButton_pressed():
	get_tree().paused = false
	var err = get_tree().change_scene("res://scenes/Home.tscn")
	if err != OK:
		push_error("change_scene failed")


func _on_ResumeButton_pressed():
	get_tree().paused = false
	self.queue_free()
