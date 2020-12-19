extends Panel

var settings = preload("res://scenes/Settings.tscn")


func _on_SettingButton_pressed():
	var ins = settings.instance()
	get_tree().root.add_child(ins)


func _on_HomeButton_pressed():
	get_tree().change_scene("res://scenes/Home.tscn")


func _on_ResumeButton_pressed():
	self.queue_free()
