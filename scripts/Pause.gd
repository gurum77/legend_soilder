extends Panel

var settings = preload("res://scenes/Settings.tscn")


func _on_SettingButton_pressed():
	get_tree().paused = false
	var ins = settings.instance()
	add_child(ins)


func _on_HomeButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Home.tscn")


func _on_ResumeButton_pressed():
	get_tree().paused = false
	self.queue_free()
